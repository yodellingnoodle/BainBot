# BainBot
A simple multivariate analysis tool for clinicians.

This MATLAB script inputs a simple Excel spreadsheet and performs basic multivariate analysis, outputting a number of figures.
Currently, these include:
1. PCA
2. MRMR Predictor Ranking
3. Scatter Plot Matrix

The Excel spreadsheet assumes a single row for variable names with the first column exclusively reserved for patient MRNs (identifiers) and the last being your chosen output.
Any number of variables and data points can be entered with no changes to the script.

Was originally made to help with basic data analysis for MRgFUS but can, in principle, be used for anything.
