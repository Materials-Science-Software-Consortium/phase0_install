.SUFFIXES:
.SUFFIXES: .o .F .f .F90 .f90 .c .mod

# Platform    : GNU Linux (EM64T/AMD64)
# Prog. model : MPI parallel
# Compiler    : Intel oneAPI
# BLAS/LAPACK : Intel Math Kernel Library (MKL)
# FFT         : Intel MKL with FFTW3 interface
###########################################################################
###<< PLEASE CHANGE THE VARIABLES BELOW ACCORDING TO YOUR ENVIRONMENT >>###
###########################################################################
F90 = mpiifort
CC  = icc
CPP = 
AR  = ar -vq
LINK = mpiifort
F90FLAGS = -traceback
F77FLAGS = -traceback
CFLAGS = -O -DINTEL

ESM = yes
ifdef ESM
CPPESM=-DENABLE_ESM_PACK
LESM=-lesm
else
CPPESM=
endif

CPPFLAGS = -DLinux -DFFTW3 -D_POT_SMOOTHING_ -DTRANSPOSE -DGGA_ATOMIC_WITH_NEW_GNCPP -DREMOVE_PC_FROM_FORCE -D_POSITRON_ -D_FAST_WAY_ -D_USE_DATE_AND_TIME_ -DUSE_NONBLK_COMM -DRMM_NONLOCAL_NEW ${CPPESM} -D__EDA__ -DLIBRARY_BUILD
LFLAGS = 
F90FLAGS_FIXED = -extend_source -Fl -fixed
F90FLAGS_FREE = -extend_source -Fl
MKLHOME=/opt/intel/oneapi/mkl/latest/lib/intel64
INCLUDE=-I/opt/intel/oneapi/mkl/latest/include/fftw
LIBS = -L./ ${LESM}  -L/ -Wl,--start-group ${MKLHOME}/libmkl_scalapack_lp64.a ${MKLHOME}/libmkl_blacs_intelmpi_lp64.a ${MKLHOME}/libmkl_intel_lp64.a  ${MKLHOME}/libmkl_sequential.a  ${MKLHOME}/libmkl_core.a -Wl,--end-group -Bdynamic   -lpthread
###########################################################################
###<< PLEASE CHANGE THE VARIABLES ABOVE ACCORDING TO YOUR ENVIRONMENT >>###
###########################################################################

ifdef ESM
ESM_LIB = libesm.a
else
ESM_LIB =
endif
LAPACK = 
FFTOBJECT = 
OBJ_INPUTPARSE = input_parse.o

include Makefile.tmpl

PHASE_OBJECTS = $(PHASE_LOWER_MODULES) $(FFTOBJECT) $(PHASE_UPPER_MODULES) $(PHASE_F_SUBROUTINES) $(PHASE_F_OTHERSUBS) $(PHASE_OBJECTSF77) $(OBJ_INPUTPARSE)

EKCAL_OBJECTS = $(EKCAL_LOWER_MODULES) $(FFTOBJECT) $(EKCAL_UPPER_MODULES) $(EKCAL_F_SUBROUTINES) $(EKCAL_F_OTHERSUBS) $(EKCAL_OBJECTSF77) $(OBJ_INPUTPARSE)

EPS_OBJECTS = $(EPS_LOWER_MODULES) $(FFTOBJECT) $(EPS_UPPER_MODULES) $(EPS_F_SUBROUTINES) $(EPS_F_OTHERSUBS) $(EPS_OBJECTSF77) $(OBJ_INPUTPARSE)

TDLR_OBJECTS = $(TDLR_LOWER_MODULES) $(FFTOBJECT) $(TDLR_UPPER_MODULES) $(TDLR_F_SUBROUTINES) $(TDLR_F_OTHERSUBS) $(TDLR_OBJECTSF77) $(OBJ_INPUTPARSE)

all : phase ekcal epsmain tdlrmain

ifdef ESM
phase : $(ESM_LIB) $(LAPACK) $(PHASE_OBJECTS) $(NLOBJ)
	$(LINK) $(PHASE_OBJECTS) $(NLOBJ) $(LFLAGS) $(LIBS) -o $@
else
phase : $(LAPACK) $(PHASE_OBJECTS) $(NLOBJ)
	$(LINK) $(PHASE_OBJECTS) $(NLOBJ) $(LFLAGS) $(LIBS) -o $@
endif

ekcal : $(LAPACK) $(EKCAL_OBJECTS) $(NLOBJ)
	$(LINK) $(EKCAL_OBJECTS) $(NLOBJ) $(LFLAGS) $(LIBS) -o $@

epsmain : $(LAPACK) $(EPS_OBJECTS) $(NLOBJ)
	$(LINK) $(EPS_OBJECTS) $(NLOBJ) $(LFLAGS) $(LIBS) -o $@

tdlrmain : $(LAPACK) $(TDLR_OBJECTS) $(NLOBJ)
	$(LINK) $(TDLR_OBJECTS) $(NLOBJ) $(LFLAGS) $(LIBS) -o $@

ifdef NO_MPI
libesm.a:
	cd EsmPack; make INCLUDE="$(INCLUDE)" FORTRAN="$(F90)" LIBFLAG="$(LIBS)" MPIFLAG="" AR="$(AR)"
else
libesm.a:
	cd EsmPack; make INCLUDE="$(INCLUDE)" FORTRAN="$(F90)" LIBFLAG="$(LIBS)" MPIFLAG="-D__MPI__" AR="$(AR)"
endif

liblapack.a:
	cd LAPACK; make F77="$(F90)" F77FLAGS="$(F77FLAGS)" AR="$(AR)"

libblas.a:
	cd BLAS; make F77="$(F90)" F77FLAGS="$(F77FLAGS)" AR="$(AR)"

$(OBJ_INPUTPARSE):$(@:.o=.c) $(@:.o=.h)
	$(CC) -c $(CFLAGS) $(@:.o=.c)

.f.o:
	$(F90) -c $(F77FLAGS) $*.f

.f90.o:
	$(F90) -c $(F90FLAGS) $*.f90

.F.o:
	$(F90) -c $(F77FLAGS) $(CPPFLAGS) $*.F

.F90.o:
	$(F90) -c $(F90FLAGS) $(CPPFLAGS) $*.F90

clean:
	\rm -f *.o *.mod *.a *.lib *.L *.list phase ekcal epsmain tdlrmain
	\cd LAPACK; make clean
	\cd BLAS; make clean
	\cd EsmPack; make clean

install: phase ekcal epsmain tdlrmain
	\mv -f phase ../bin/
	\mv -f ekcal ../bin/
	\mv -f epsmain ../bin/
	\mv -f tdlrmain ../bin/
