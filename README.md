# TurbineOpti  <img align="right" src="images/streamlines_contoured_top.png" width="200" />
A collection of Matlab scripts used for the kriging surrogate model assisted optimization of low speed turbine endwalls

## Introduction
This software was originally written for the MathWorks Matlab&trade; runtime, as an automated design optimization routine for non-axisymmetric turbine endwalls. 

The optimization approach is based on the so-called DACE (Design of Computer Experiments - "Efficient Global Optimization of Expensive Black-Box Functions" of Jones, Schonlau & Welch 1998), which itself is based on the geostatistical "Kriging" method for estimating mineral deposits. 

Currently, the scripts are designed for used with the following 3rd party software:

* Base geometry generation (Gambit&trade;)
* Mesh generation (Ansys ICEMCFD&trade; Rel 12)
* CFD solver (Ansys Fluent&trade; Rel 12)

but it should not be difficult to subsitute alternative providers as required. 

The software has already been integrated with OpenFOAM&trade; but these scripts are not included at this stage. Please contact the author(s) if you are interested in obtaining these. 

### Getting started
In order to start an optimization run, you will need (in addition to having configured the CFD / mesh generation tools / paths) to set up a database of starting database from which the first surrogate model can be built. This requires x2 files:

* `XY.mat` (a data file containing initial design vectors and associated OF values), and
* `thetas.mat` (a data file containing (optimized) kriging model parameters for each dimension of the model)

Both files are in the Matlab&trade; binary `.mat` format.

#### XY.mat
This should should contain x2 structures:

* A matrix `X` `(n x m)` where each column m = a vector of values representative of the design to be optimized (i.e. the design vector), therefore the database size = `m` and design vector dimensionality = `n`, and
* A column vector `Y` `(1 x m)` where each entry corresponds to each of the design vectors in `X`

#### theta.mat
This file contains a simple column vector `theta` `(1 x n)` where each component represents the theta hyperparameter for the corresponding dimension of the design vector. 

Two sample files (`XY.mat` and `thetas.mat`) are included in the repository, for a sample problem (`n = 12`). Of course, these data structures should be changed to correspond to the geometry of the current problem.

## Running the code
The code can be run with a GUI or headlessly. Both start up scripts are included. 

* `TurbineOpti.m -> GUI version`
* `TurbineOpti_nogui.m -> headless version`

Currently the code also requires the use of the Matlab&trade; Parallel Toolbox to accelerate the model fitting / optimization sub-procedures, however the use of the `parloop` structures are reasonably sparse and are trivial to remove if the toolbox is not available.

### Issues
Its possible that some scripts may be missing initially from this repository, so please log an issue or contact the author(s) should you find this. Thank you!

## Literature
This code was used as the basis of the designs produced for:

_Bergh, J and Snedden, GC (2015) "Evaluation of the effectiveness of various metrics used in the design of non-axisymmetric turbine endwall contours", In proceedings of 22nd International Symposium on Air Breathing Engines (ISABE2015)_

_Bergh, J (2018) "On the Evaluation of Common Design Metrics for the Optimization of Non-Axisymmetric Endwall Contours for a 1-stage Turbine Rotor", PhD thesis, University of Cape Town, South Africa_


## Citation
Citing this work:

    Bergh, J (2018) "On the Evaluation of Common Design Metrics for the Optimization of Non-Axisymmetric 
    Endwall Contours for a 1-stage Turbine Rotor", PhD thesis, University of Cape Town, South Africa
