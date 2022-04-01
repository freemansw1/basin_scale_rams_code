#!/bin/bash


#Script to prepare RAMS for compiling in single or double precision.

#Execute script something like prep_precision.sh 6.2.11 2
# where 1=single precision and 2=double precision

versionnum=$1 #RAMS version number such as "6.2.11"
precisionnum=$2 #1=single, 2=double

if [ "$versionnum" == "" ] || [ "$precisionnum" == "" ]; then
  echo " "
  echo "Please input version number and precision arguments such as"
  echo " prep_precision.sh <version number> <precision number>"
  echo " where <6.2.11> might be the version number and"
  echo " 1=single precision and 2=double precision."
  echo " "
  echo "Example: (prep_precision.sh 6.2.11 1)"
  echo " sets up version 6.2.11 for single precision"
  echo " "
  exit
fi
if [ ! -d src/$versionnum ]; then
  echo " "
  echo "RAMS version you are trying to set up is not here."
  echo " "
  exit
fi
if [ $precisionnum -lt 1 ] || [ $precisionnum -gt 2 ]; then
  echo " "
  echo "Precision flag choice is not one of the options."
  echo " "
  exit
fi

if [ $precisionnum -eq 1 ];then
 echo " "
 echo "Setting up single precision for RAMS verion $versionnum."
 echo " "
 if [ -f ./src/$versionnum/include/utils_sub_names_SP.h ]; then
  cp ./src/$versionnum/include/utils_sub_names_SP.h \
     ./src/$versionnum/include/utils_sub_names.h
 else
  echo "Precision specific file utils_sub_names_SP.h does not exist."
  echo " "
  exit
 fi
elif [ $precisionnum -eq 2 ];then
 echo " "
 echo "Setting up double precision for RAMS verion $versionnum."
 echo " Note that double precision simulations require much more"
 echo " compute time and generate much larger output files."
 echo " "
 if [ -f ./src/$versionnum/include/utils_sub_names_DP.h ]; then
  cp ./src/$versionnum/include/utils_sub_names_DP.h \
     ./src/$versionnum/include/utils_sub_names.h
 else
  echo "Precision specific file utils_sub_names_DP.h does not exist."
  echo " "
  exit
 fi
fi

