
SRCFILES = lbm2D.o lbm3D.o util.o

# uncomment to use Intel compiler
# CC = icc

# compiler options
CCOPTS = -Wall -m64 -O3 -lm -DNDEBUG


all: proj_sim2D_freesurf proj_sim3D proj_sim3D_freesurf


proj_sim2D_freesurf: ${SRCFILES} lbm_sim2D_freesurf.o
	${CC} -o lbm_sim2D_freesurf $? ${CCOPTS}

proj_sim3D: ${SRCFILES} lbm_sim3D.o
	${CC} -o lbm_sim3D $?  ${CCOPTS}

proj_sim3D_freesurf: ${SRCFILES} lbm_sim3D_freesurf.o
	${CC} -o lbm_sim3D_freesurf $? ${CCOPTS}


lbm2D.o: ../src/lbm2D.c
	${CC} -c -I../include ${CCOPTS} $<

lbm3D.o: ../src/lbm3D.c
	${CC} -c -I../include ${CCOPTS} $<

util.o: ../src/util.c
	${CC} -c -I../include ${CCOPTS} $<


lbm_sim2D_freesurf.o: ../test/lbm_sim2D_freesurf.c
	${CC} -c -I../include ${CCOPTS} $<

lbm_sim3D.o: ../test/lbm_sim3D.c
	${CC} -c -I../include ${CCOPTS} $<

lbm_sim3D_freesurf.o: ../test/lbm_sim3D_freesurf.c
	${CC} -c -I../include ${CCOPTS} $<


clean:
	rm *.o
