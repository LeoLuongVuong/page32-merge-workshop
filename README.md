# page32-merge-workshop

Example code used for the MeRGE workshop at the 32nd PAGE meeting in Rome, Italy.


This workshop focused on the packages that are showcased in the [MeRGE Expo 1 website](https://merge.metrumrg.com/expo/expo1-nonmem-foce/) and the code in this repo is a simplified version of code maintained in the [MeRGE Expo 1 GitHub Repo](https://github.com/metrumresearchgroup/expo1-nonmem-foce/).

## Directory listing

~~~
   /model = the NONMEM-formatted model files (.ctl)

   /script = the scripts that were demonstrated during the workshop
   
   /data = simulated data and spec files, to use as example "observed" data
   
   /deliv = example "deliverables" (i.e. figures and tables)
   
   /presentation = a pdf file with the hands-on slides for the workshop
   
   /renv = package management scaffolding
   
   /bin = empty directory for installing bbi into (see below)
~~~


## Installing packages with `pkgr`

This repository includes a `pkgr.yml` file with all relevant packages. If you have `pkgr` installed, you can follow the steps below to install your packages. (If you are on Metworx, you will have `pkgr` installed.) 

**In your terminal**

~~~
# cd to this repo directory
pkgr install
~~~

Once `pkgr` finishes installing, restart your R session.

**In your R console**

The following command will install the `bbi` command line utility, which `bbr` uses.

~~~
bbr::use_bbi()
~~~

Run the above in your R console and answer "yes" to the prompts.
