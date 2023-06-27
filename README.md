# GETI_scripts
These scripts were used to evaluate the tension sensors
![image](https://github.com/DGabrielaitis/GETI_scripts/assets/39090323/697c6db7-1b31-4654-b5a5-4c4f29004fc3)
How to run the pipeline?

1. For every construct, create 3 (or 1-4) folders names exp# (exp1, exp2, etc). In which there should be a single file, containing the data exported by the NIS elements software. It should be an excel spreadsheat. IN the spreadsheat, every well/fov should be on a separate sheet, names W1I1, W1I2, etc. the code can do up to 2 wells and 5 images. For every time-lapse, the last ROI shoudl be the BACKGROUND!!!!!
2. If you did not merge the channels, when imaging, use 1_cpGFP-mOrange_Normalisation_w_backgroundremoval_V1.R. If they are merged, use 1_cpGFP-mOrange_Normalisation_w_backgroundremoval_V2.R In the code, it is assumed, that you will normalise all of your data by the 30th image, check if that is correct for your data. In case you are analysing a Hypoosmotic shock experiment, use the 1_FRET-HYPOOSM_V2.R code. In case of bad normalisation, always check the wchich time point is used in the normalisation function. Run this code for every experiment.
3. Afterwards, you will get up to 10 new excel files, whith every fov as a separate sheet. Manually chech the traces, remove the bad ones. 
4. After you have manually checked the data, run 1_cpGFP-mOrange_Finalisation.R (it should be in the folder in which you have stored the experiment folders.
5. The final script will make a new excel sheet that will have the average, stdev and N for all of your experiment. You can ploit this in any software you please. It will always have the GFP and mOrange2 control in parallel. 


