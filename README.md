
## Texform Generation Code

Step 1. Create input images -- objects on a uniform gray background.
Step 2. Run the algorithm on one image. You should open texformDemo.m and play around.

You can skip Step 1 if you just want to try out the algorithm and see what it's like.

Dependencies: This code requires a working version of Matlab (most recently used -- 2015a) as well as the matlabpyrtools, which are included in the second folder with the rest of the metamer code. Practically, note that usually we run this code on a computing cluster rather than locally as it takes 8 hours to finish generating one image (for all 50 iterations). However, the main goal of this script is to provide transparency on the procedures used to generate the input images to the algorithm, which were selected with some care.

The bulk of this code comes from another codebase originally writted by  Jeremy Freeman : https://github.com/freeman-lab/metamers. Details for this algorithm can be found in the original paper, seen:
https://www.nature.com/articles/nn.2889

This code has been used to generate stimuli used in Long, Konkle, Cohen, & Alvarez (2016),  Long, Störmer, & Alvarez, (2017), Long & Konkle (2017), and Long, Yu, and Konkle (2017, bioRxiv).If you have any questions, please email brialorelle@gmail.com. 

