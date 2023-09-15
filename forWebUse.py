from cust_Dataset import *
from Models import *
import os

dim_per_resi_feas=10

def for_TEST_experi(model, loader):
    model.eval()

    all_DNA_bind_preds = []

    for batch_idx, (feas_pro_s1, feas_pro_s2) in enumerate(loader):
        with torch.no_grad():

            temp_feas_pro_var_s1 = torch.autograd.Variable(feas_pro_s1.to(torch.float32).to(device))
            feas_pro_var_s1 = temp_feas_pro_var_s1.view(-1, fixed_window, dim_per_resi_feas)
            feas_pro_var_s2 = torch.autograd.Variable(feas_pro_s2.to(torch.float32).to(device))

        DNA_bind_preds = model(feas_pro_var_s1, feas_pro_var_s2)

        all_DNA_bind_preds.append(DNA_bind_preds.data.cpu().numpy())
    all_DNA_bind_preds = np.concatenate(all_DNA_bind_preds, axis=0).flatten()

    print("Predicted results: Done")
    return all_DNA_bind_preds


#-------------------------------------------------------------#
#
#  main function is as below
#
#-------------------------------------------------------------#
test_dataSet = dataSet()
print('===========================')
print('dataset is done')

myModel = MainModel(input_feas_FCL, TRF_input).to(device)

print('===========================')
print('Model Construction is done')


test_loader = DataLoader(test_dataSet, batch_size=128, pin_memory=True, num_workers=8, drop_last=False)
print('===========================')
print('Data loader is done')

DNA_preds = []

path_dir = "./final_model/"
myModel.load_state_dict(torch.load(os.path.join(path_dir, 'model_weights.dat')))

DNA_preds= for_TEST_experi (model=myModel, loader=test_loader)
print("Test: Done")

pred_dir = "./final_preds/"
if not os.path.exists(pred_dir):
    os.makedirs(pred_dir)

with open('final_preds/DNA_preds.txt', 'w', encoding="utf-8") as fw_pred:
    for idx, values in enumerate(DNA_preds):
        values=values*5.2
        fw_pred.write(str(round(values, 5))+"\n")
fw_pred.close()


