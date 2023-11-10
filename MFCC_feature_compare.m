function match= MFCC_feature_compare(testing_data1,speakerGmm)
No_of_Gaussians=12;  %the number of Gaussian Mixtures which will be used in modeling
%no_coeff=[1];
 no_coeff=[5:12];     
% load(mfcc_file);
Fs=8000;
testing_features=melcepst(testing_data1,8000');
load speakerData;

% disp('testing_features');size(testing_features)
max=-100e+10;

% fea cell array holds the features of the persons
% f=statusbar('Comparing');
for i=1:length(speakerGmm)
%     f=statusbar((i/5),f);
    mu_t =speakerGmm(i).mu;
    sigma_t=speakerGmm(i).sigm;
    c_t=speakerGmm(i).c;
    [lYM,lY]=lmultigauss(testing_features(:,no_coeff)', mu_t,sigma_t,c_t);
    maxv(i)=mean(lY);
end
match=maxv;
% delete(statusbar);