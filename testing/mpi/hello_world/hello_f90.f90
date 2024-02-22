! Sample MPI "hello world" application using the Fortran mpi module
! bindings.
!
program main
    use mpi
    implicit none
    integer :: ierr, rank, size, len
    character(len=MPI_MAX_LIBRARY_VERSION_STRING) :: version

    call MPI_INIT(ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierr)
    call MPI_GET_LIBRARY_VERSION(version, len, ierr)

    write(*, '("Hello, world, I am ", i2, " of ", i2, ": ", a)') &
          rank, size, version

    call MPI_FINALIZE(ierr)
end
