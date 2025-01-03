import torch
import numpy as np
import math

from torch.utils.data import Dataset
from torch.utils.data import DataLoader
from torch import nn as nn

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
# ===================================================
# Transformer model parameters (per-residue features)
TRF_input=10
d_ff = 128
d_k = d_v = 32
n_heads = 8
n_layers = 3
TRF_output = 10
fixed_window = 15

input_feas_part2=20
feas_dim1=20

# fully-connected layer parameters (Combining the above three layers)
pred_dim1 = 20
pred_dim2 = 10
pred_dim3 = 5
# ===================================================

class MainModel(nn.Module):
    def __init__(self, TRF_input, input_feas_part2):
        super(MainModel, self).__init__()

        # --------------------------------------------------------------------------

        self.transformer_layer = Transformer(TRF_input, input_feas_part2, TRF_output)

        self.PredLayer = nn.Sequential()
        self.PredLayer.add_module('PredLayer', PredLayer(TRF_output, pred_dim1, pred_dim2, pred_dim3))
        # --------------------------------------------------------------------------

    def forward(self, pro_feas_s1, pro_feas_s2):

        output_TRF = self.transformer_layer(pro_feas_s1,pro_feas_s2)
        final_pred_output = self.PredLayer(output_TRF)

        return final_pred_output


class PredLayer(nn.Module):
    def __init__(self, input_feas_dim, dim1, dim2, dim3):
        super(PredLayer, self).__init__()

        self.bind_pred_layer = nn.Sequential()
        self.bind_pred_layer.add_module("bind_pred_layer1", nn.Linear(input_feas_dim, dim1, bias=False))
        self.bind_pred_layer.add_module("ReLU1", nn.ReLU())
        self.bind_pred_layer.add_module("bind_pred_layer2", nn.Linear(dim1, dim2))
        self.bind_pred_layer.add_module("ReLU2", nn.ReLU())
        self.bind_pred_layer.add_module("bind_pred_layer3", nn.Linear(dim2, dim3))
        self.bind_pred_layer.add_module("ReLU3", nn.ReLU())
        self.bind_pred_layer.add_module("bind_pred_layer4", nn.Linear(dim3, 1))
        self.bind_pred_layer.add_module("sigmod", nn.Sigmoid())

    def forward(self, x):

        out_pred = self.bind_pred_layer(x)
        return out_pred

class Fully_connected_3layers(nn.Module):
    def __init__(self, input_feas_dim, dim1, dim2, dim3):
        super(Fully_connected_3layers, self).__init__()
        self.linear1 = nn.Linear(input_feas_dim, dim1, bias=False)
        self.activation1 = nn.ReLU()
        self.linear2 = nn.Linear(dim1, dim2)
        self.activation2 = nn.ReLU()
        self.linear3 = nn.Linear(dim2, dim3)
        self.activation3 = nn.ReLU()

    def forward(self, x):
        features = self.linear1(x)
        features = self.activation1(features)
        features = self.linear2(features)
        features = self.activation2(features)
        features = self.linear3(features)
        FCL3layers_output = self.activation3(features)

        return FCL3layers_output
# ===================================================
# ===================================================
class Transformer(nn.Module):
    def __init__(self,d_model, input_feas_part2, TRF_output):
        super(Transformer, self).__init__()
        self.encoder = Encoder(d_model)  # checking
        self.projection = nn.Linear(d_model, TRF_output, bias=False)

    def forward(self, enc_inputs,fixed_inputs):
        enc_outputs, enc_self_attns = self.encoder(enc_inputs,fixed_inputs)
        dec_logits = self.projection(enc_outputs)

        # return dec_logits.view(-1,dec_logits.size(-1)), enc_self_attns
        # print(dec_logits)
        mid_window_scores = dec_logits[:, fixed_window // 2, :]

        return mid_window_scores.squeeze(1)


class Encoder(nn.Module):
    def __init__(self,d_model):
        super(Encoder, self).__init__()
        self.pos_emb = PositionalEncoding(d_model)  # checked
        self.layers = nn.ModuleList(EncoderLayer(d_model) for _ in range(n_layers))  # checking

    def forward(self, enc_inputs,fixed_inputs):
        enc_outputs = self.pos_emb(enc_inputs.transpose(0, 1)).transpose(0, 1)
        enc_self_attn_mask = get_attn_pad_mask()

        enc_self_attns = []
        for layer in self.layers:
            enc_outputs, enc_self_attn = layer(enc_outputs, enc_self_attn_mask)
            enc_self_attns.append(enc_self_attn)
        return enc_outputs, enc_self_attns


class PositionalEncoding(nn.Module):
    def __init__(self, d_model, dropout=0.1, max_len=5000):
        super(PositionalEncoding, self).__init__()
        self.dropout = nn.Dropout(p=dropout)
        pe = torch.zeros(max_len, d_model)
        position = torch.arange(0, max_len, dtype=torch.float).unsqueeze(1)
        div_term = torch.exp(torch.arange(0, d_model, 2).float() * (-math.log(10000.0) / d_model))

        pe[:, 0::2] = torch.sin(position * div_term)
        pe[:, 1::2] = torch.cos(position * div_term)
        # pe [max_len,d_model]
        pe = pe.unsqueeze(0).transpose(0, 1)
        self.register_buffer('pe', pe)

    def forward(self, x):  # x: [seq_len, batch_size, d_model]
        x = x + self.pe[:x.size(0), :]
        return self.dropout(x)


class EncoderLayer(nn.Module):
    def __init__(self,d_model):
        super(EncoderLayer, self).__init__()
        self.enc_self_attn = MultiHeadAttention(d_model)
        self.pos_ffn = PoswiseFeedForwardNet(d_model)

    def forward(self, enc_inputs, enc_self_attn_mask):
        enc_outputs, attn = self.enc_self_attn(enc_inputs, enc_inputs, enc_inputs, enc_self_attn_mask)
        enc_outputs = self.pos_ffn(enc_outputs)
        return enc_outputs, attn


class MultiHeadAttention(nn.Module):
    def __init__(self,d_model):
        super(MultiHeadAttention, self).__init__()

        self.W_Q = nn.Linear(d_model, d_k * n_heads, bias=False)
        self.W_K = nn.Linear(d_model, d_k * n_heads, bias=False)
        self.W_V = nn.Linear(d_model, d_v * n_heads, bias=False)

        self.fc = nn.Linear(n_heads * d_v, d_model, bias=False)
        self.layer_norm = nn.LayerNorm(d_model)

    def forward(self, input_Q, input_K, input_V, attn_mask):
        residual, batch_size = input_Q, input_Q.size(0)

        Q = self.W_Q(input_Q).view(batch_size, -1, n_heads, d_k).transpose(1, 2)
        K = self.W_K(input_K).view(batch_size, -1, n_heads, d_k).transpose(1, 2)
        V = self.W_V(input_V).view(batch_size, -1, n_heads, d_v).transpose(1, 2)

        attn_mask = attn_mask.unsqueeze(1).repeat(1, n_heads, 1, 1).to(device)
        context, attn = ScaledDotProductAttention()(Q, K, V, attn_mask)

        context = context.transpose(1, 2).reshape(batch_size, -1, n_heads * d_v)

        output = self.fc(context)
        output = self.layer_norm(output + residual)
        return output, attn


class ScaledDotProductAttention(nn.Module):
    def __init__(self):
        super(ScaledDotProductAttention, self).__init__()

    def forward(self, Q, K, V, attn_mask):
        scores = torch.matmul(Q, K.transpose(-1, -2)) / np.sqrt(d_k)
        scores.masked_fill_(attn_mask, -1e9)
        attn = nn.Softmax(dim=-1)(scores)

        context = torch.matmul(attn, V)
        return context, attn


class PoswiseFeedForwardNet(nn.Module):
    def __init__(self,d_model):
        super(PoswiseFeedForwardNet, self).__init__()
        self.fc = nn.Sequential(
            nn.Linear(d_model, d_ff, bias=False),
            nn.ReLU(),
            nn.Linear(d_ff, d_model, bias=False),
            nn.LayerNorm(d_model)
        )

    def forward(self, inputs):
        residual = inputs
        output = self.fc(inputs)
        return (output + residual)


# ------------------------------------------------
#
#
# ------------------------------------------------


def get_attn_pad_mask():
    oriMask = [[False] * fixed_window for _ in range(fixed_window)]
    for row in range(len(oriMask[0])):
        for col in range(len(oriMask[1])):
            oriMask[row][col] = True

    pad_attn_mask = torch.Tensor(oriMask).bool().to(device)

    return pad_attn_mask.expand(1, fixed_window, fixed_window)

# ===================================================
# ===================================================
class AverageMeter(object):

    def __init__(self):
        self.reset()

    def reset(self):
        self.val = 0
        self.avg = 0
        self.sum = 0
        self.count = 0

    def update(self, val, n=1):
        self.val = val
        self.sum += val * n
        self.count += n
        self.avg = self.sum / self.count
# ===================================================
# ===================================================


