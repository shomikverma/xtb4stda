
PROG    = xtb4stda

OSTYPE=MACOS
#--------------------------------------------------------------------------

#-------------------------------------------------------------------------

ifeq ($(OSTYPE),LINUXI)
   FC = ifort
  # FC = lfc
   CC = gcc

  ### multithread ###
   LINKER = ifort -static -qopenmp  -I$(MKLROOT)/include/intel64/lp64 -I$(MKLROOT)/include
    LIBS = $(MKLROOT)/lib/intel64/libmkl_blas95_lp64.a $(MKLROOT)/lib/intel64/libmkl_lapack95_lp64.a -Wl,--start-group $(MKLROOT)/lib/intel64/libmkl_intel_lp64.a $(MKLROOT)/lib/intel64/libmkl_core.a $(MKLROOT)/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -lpthread -lm

  ### sequential ###
  # LINKER = ifort -static
  # LIBS = ${MKLROOT}/lib/intel64/libmkl_blas95_lp64.a ${MKLROOT}/lib/intel64/libmkl_lapack95_lp64.a -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_lp64.a ${MKLROOT}/lib/intel64/libmkl_core.a $(MKLROOT)/lib/intel64/libmkl_sequential.a -Wl,--end-group -lpthread -lm

   CFLAGS = -O -DLINUX
   FFLAGS = -O3 -qopenmp -I$(MKLROOT)/include/intel64/lp64 -I$(MKLROOT)/include
endif

ifeq ($(OSTYPE),MACOS)
    FC = ifort
    CC = gcc
    LINKER = ifort  -qopenmp  -I$(MKLROOT)/include/intel64/lp64 -I$(MKLROOT)/include
    LIBS =  ${MKLROOT}/lib/libmkl_blas95_lp64.a ${MKLROOT}/lib/libmkl_intel_lp64.a ${MKLROOT}/lib/libmkl_intel_thread.a ${MKLROOT}/lib/libmkl_core.a -liomp5 -lpthread -lm -ldl
    PREFLAG = -E -P
    FFLAGS = -O3 -qopenmp -I$(MKLROOT)/include/intel64/lp64 -I$(MKLROOT)/include #-check all
    FFLAGS = -O3  -I${MKLROOT}/include/intel64/lp64 -I${MKLROOT}/include
    CCFLAGS = -O3 -DLINUX
endif

#################################################
OBJS=\
     asym.o atovlp.o axis.o axis2.o axis3.o blckmgs.o block.o\
		 blowsy.o cm5.o copyc6.o dftd3.o dipole.o drsp.o dtrafo.o dtrafo2.o elem.o fermi.o\
		 foden.o fragment.o gauss.o gbobc.o gover.o iniq.o intpack.o lin.o local.o\
		 lopt.o main.o makel.o matinv.o molbld.o ncoord.o ncoord2.o\
		 neighbor.o onetri.o out.o pop.o pqn.o printbas.o printmold.o printmos.o\
		 prmat.o qsort.o rdcoord2.o readl.o readl2.o readparam.o setmetal.o setwll.o\
		 shifteps.o shiftlp.o spline.o spline2.o splitmol.o symtranslib.o timing.o\
		 uxtb.o valel.o warn.o wrc0.o wrcoord.o wren.o wrxyz.o xbasis.o xtb.o zmatpr.o
%.o: %.f90
	@echo "making $@ from $<"
	$(FC) $(FFLAGS) -c $< -o $@
%.o: %.f
	@echo "making $@ from $<"
	$(FC) $(FFLAGS) -c $< -o $@

$(PROG):     $(OBJS)
		@echo  "Loading $(PROG) ... "
		@$(LINKER) $(OBJS) $(LIBS) -o $(PROG)

clean:
	rm -f *.o *.mod $(PROG)
