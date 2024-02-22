! Sample MPI "hello world" application using the Fortran mpi_f08
! module bindings.
!
program main
    use mpi_f08
    implicit none
    integer :: rank, size, len
    character(len=MPI_MAX_LIBRARY_VERSION_STRING) :: version

    call MPI_INIT()
    call MPI_COMM_RANK(MPI_COMM_WORLD, rank)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, size)
    call MPI_GET_LIBRARY_VERSION(version, len)

    write(*, '("Hello, world, I am ", i2, " of ", i2, ": ", a)') &
          rank, size, version

    call MPI_FINALIZE()
end
