import numpy
import torch
import numpy as np
from collections import OrderedDict

from torch.utils import data

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
dim_per_resi_feas_s1 = 10
dim_per_resi_feas_s2 = 20
fixed_window = 15
#===================================================================


def get_data_mess():

    allproID_feas = OrderedDict()
    all_proID = []
    proID="temp_pro"

    allproID_feas[proID] = {}
    all_proID.append(proID)
    pro_feas_s1 = []
    pro_feas_s2 = []
    with open('feasfolder/temp_pro.txt'.format(proID), 'r') as fr_pro_feas:
         for everyline in fr_pro_feas:
            everyline = everyline.strip()
            if everyline:
                everyline = [float(i) for i in everyline.split(',')]
                pro_feas_s1.append(everyline[0:10]) #for TRF feas
                pro_feas_s2.append(everyline[10:])
    allproID_feas[proID]['pro_feas_s1'] = pro_feas_s1
    allproID_feas[proID]['pro_feas_s2'] = pro_feas_s2
#---------------------------------------------------------------------
# ---------------------------------------------------------------------
    return allproID_feas, all_proID

class dataSet(data.Dataset):
    def __init__(self):
        self.window_size = fixed_window
        self.allproID_features, self.allproteinID = get_data_mess()

        self.all_samples_list = []

        all_count=-1
        for idx_proID, key_proID in enumerate(self.allproteinID):
            for jdx, sbind in enumerate(self.allproID_features[key_proID]['pro_feas_s1']):
                all_count += 1

                temp_s = [all_count, idx_proID, jdx, len(self.allproID_features[key_proID]['pro_feas_s1'])]
                self.all_samples_list.append(temp_s)


    def __getitem__(self, samp_idx):

        count, proid_idx, resi_jdx, this_seq_len = self.all_samples_list[samp_idx]
        proid_idx, resi_jdx, this_seq_len = int(proid_idx), int(resi_jdx), int(this_seq_len)

        # =============================================
        get_pro_feas_s2 = numpy.array(self.allproID_features[self.allproteinID[proid_idx]]['pro_feas_s2'])[resi_jdx, :]
        # =============================================


        half_size = self.window_size//2

        win_start = resi_jdx - half_size
        win_end = resi_jdx + half_size
        valid_end = min(win_end, this_seq_len - 1)

        pre_zeros_PADs=None
        post_zeros_PADs=None
        #-----------------------------------------------
        if win_start < 0:
            pre_zeros_PADs = np.zeros((0 - win_start, dim_per_resi_feas_s1))

        win_start = max(0, win_start)

        valid_features = numpy.array(self.allproID_features[self.allproteinID[proid_idx]]['pro_feas_s1'])[win_start:valid_end + 1,:]

        if valid_end < win_end:
            post_zeros_PADs = np.zeros((win_end - valid_end, dim_per_resi_feas_s1))

        if pre_zeros_PADs is not None:
            valid_features = np.concatenate([pre_zeros_PADs, valid_features], axis=0)
        if post_zeros_PADs is not None:
            valid_features = np.concatenate([valid_features, post_zeros_PADs], axis=0)

        valid_features = valid_features[np.newaxis, :, :]
        get_pro_feas_s1 = valid_features

        #=============================================
        #=============================================
        return get_pro_feas_s1, get_pro_feas_s2
        #=============================================
    def __len__(self):
        return len(self.all_samples_list)

    def get_all_pro_ID(self):
        return self.proteinID

