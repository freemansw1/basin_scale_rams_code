!##############################################################################
Module node_mod

use grid_dims

implicit none

!---------------------------------------------------------------------------
! For the blocking and non-blocking MPI send/receive pairings, tags are used
! to help uniquely identify all of the different messages. At this point,
! the following routines use MPI send/receives and thus need tags.
!
!          File                Routine
!
!     mpass_oda.f90       masterput_oda()
!                         nodeget_oda()
!
!     mpass_nest.f90      node_send_ctile()
!
!     mpass_lbc.f90       node_sendlbc()
!
!     mpass_cyclic.f90    node_sendcyclic()
!
!
! The actual tags are generated by adding things like grid numbers or
! variable numbers to the tag base. This doesn't guarantee that they
! remain unique, but if the bases are chosen sufficiently far apart,
! then the tags will remain unique.
!
integer, parameter :: ODA_TAG_BASE         = 10000

integer, parameter :: CTILE_TAG_BASE       = 20000

integer, parameter :: LBOUND_TAG_BASE      = 30000

integer, parameter :: CYCLIC_TAG_BASE      = 40000


! Arbitrarily set this to 20. This is used for setting buffer sizes in
! para_init.f90 and rnode.f90.
integer, parameter :: NUM_NEST_VARS = 20

!---------------------------------------------------------------------------
! The following parameters are coding for the LBC (lateral boundary) update
! routines node_sendlbc_vgroup() and node_getlbc_vgroup(). These are also used by
! update_cyclic().
integer, parameter :: LBC_ALL_VARS      = 0
integer, parameter :: LBC_ALL_INIT_VARS = 1
integer, parameter :: LBC_ALL_SCALARS   = 2
integer, parameter :: LBC_UP            = 3
integer, parameter :: LBC_VP            = 4
integer, parameter :: LBC_PP            = 5
integer, parameter :: LBC_WP            = 6

!---------------------------------------------------------------------------
! The following parameters are used by interp_fine_grid() routine, "IFG", to
! signal which subsystem is calling interp_fine_grid() and thus which set
! of variables to initialize.
integer, parameter :: IFG_HH_INIT    = 1    ! horizontal homogeneous init
integer, parameter :: IFG_VF_INIT    = 2    ! var file init
integer, parameter :: IFG_HIST_INIT  = 3    ! history init
integer, parameter :: IFG_MKVF_INIT  = 4    ! init during MAKEVFILE
integer, parameter :: IFG_MKHF_INIT  = 5    ! init during MAKEHFILE
integer, parameter :: IFG_TOPT1_INIT = 6    ! init during MAKESFC (topography)
integer, parameter :: IFG_TOPT2_INIT = 7    ! init during MAKESFC (topography)
integer, parameter :: IFG_SST_INIT   = 8    ! init during MAKESFC (sea surface temp)

!---------------------------------------------------------------------------
integer :: mainnum,nmachs,my_mpi_num,not_a_node,my_rams_num
integer, dimension(maxmach)            :: machnum
integer, dimension(maxmach,maxgrds)    :: ixb,ixe,iyb,iye
integer, dimension(maxmach,maxgrds,4)  :: nextnode
real, dimension(maxmach)               :: hperf
real, dimension(maxmach,maxgrds)       :: perf
!---------------------------------------------------------------------------

!---------------------------------------------------------------------------
integer :: mxp,myp,mzp,ia,iz,ja,jz,i0,j0,ibcon  &
          ,ia_1,ia_2,ia_3,ia1,ia2,ia3,ja_1,ja_2,ja_3,ja1,ja2,ja3  &
          ,iz_1,iz_2,iz_3,iz1,iz2,iz3,jz_1,jz_2,jz_3,jz1,jz2,jz3  &
          ,izu,jzv,mxyzp,mxysp,mxyp
!---------------------------------------------------------------------------
! ct* vars are for "coarse tiles" in the parallel nesting scheme
integer, dimension(maxgrds) :: mmxp,mmyp,mmzp,mmxyzp,mmxysp,mmxyp,mmxyzbp & 
      ,mmxyzkp,mia,miz,mja,mjz,mi0,mj0,mibcon,mxbeg,mxend,mybeg,myend &
      ,fd_sw_num,fd_nw_num,fd_se_num,fd_ne_num &
      ,ctxbeg,ctxend,ctybeg,ctyend,cti0,ctj0,ctnxp,ctnyp,ctnzp
!---------------------------------------------------------------------------
integer, dimension(nxpmax,maxgrds) :: ctipm
integer, dimension(nypmax,maxgrds) :: ctjpm
integer, dimension(nzpmax,maxgrds) :: ctkpm
!---------------------------------------------------------------------------
type io_descrip
  integer :: xblock
  integer :: yblock
  integer :: xoff
  integer :: yoff
end type io_descrip

integer, dimension(maxgrds) :: file_xchunk, file_ychunk
type (io_descrip), dimension(maxgrds) :: mem_read,mem_write,file_read,file_write
!---------------------------------------------------------------------------
integer, dimension(5,7,maxgrds,maxmach) :: ipaths
integer, dimension(6,maxgrds,maxmach)   :: iget_paths
!---------------------------------------------------------------------------
integer                       :: newbuff_feed,nbuff_feed
!---------------------------------------------------------------------------
integer, dimension(maxmach) :: irecv_req,isend_req
!---------------------------------------------------------------------------

type lbc_buff_type
   real, allocatable :: lbc_send_buff(:),lbc_recv_buff(:)
   integer :: nsend,nrecv
end type

type (lbc_buff_type) :: node_buffs(maxmach)

END MODULE node_mod
