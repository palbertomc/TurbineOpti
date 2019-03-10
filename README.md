# TurbineOpti
A collection of Matlab scripts used for the kriging surrogate model assisted optimization of low speed turbine endwalls

## Introduction
This software was originally written for the MathWorks Matlab runtime, as an automated design optimization routine for non-axisymmetric turbine endwalls. 

This because of the computational expense associated with the simulation of the (fluid) flows involved, the optimization approach is based on the so-called DACE (Design of Computer Experiments - "Efficient Global Optimization of Expensive Black-Box Functions" of Jones, Schonlau & Welch 1998), which itself is based on the geostatistical "Kriging" method for estimating mineral deposits. 

Currently, the scripts are designed for used with the following 3rd party software:

* Base geometry generation (Gambit)
* Mesh generation (Ansys ICEMCFD)
* CFD solver (Ansys Fluent)

but it should not be difficult to subsitute alternative providers as required. The software has already been integrated with OpenFOAM but these scripts are not included at this stage. Please contact the author if you are interested in obtaining these. 

## Citation
Citing this work:
