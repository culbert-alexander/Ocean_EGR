MODULE ArrMod

  ! Variables for arrival information
  IMPLICIT NONE
  INTEGER, PARAMETER   :: ARRFile = 36
  INTEGER              :: MaxNArr
  INTEGER, ALLOCATABLE :: NArr( :, : ), NArr3D( :, :, : )

  TYPE Arrival
     INTEGER :: NTopBnc, NBotBnc
     REAL    :: SrcAngle, RcvrAngle, A, Phase
     COMPLEX :: delay
  END TYPE

  TYPE(Arrival), ALLOCATABLE :: Arr( :, :, : ), Arr3D( :, :, :, : )

CONTAINS

  SUBROUTINE AddArr( omega, id, ir, Amp, Phase, delay, SrcAngle, RcvrAngle, NumTopBnc, NumBotBnc )

    ! ADDs the amplitude and delay for an ARRival into a matrix of same.
    ! Extra logic included to keep only the strongest arrivals.

    REAL,      PARAMETER :: PhaseTol = 0.5  ! arrivals with essentially the same phase are grouped into one
    INTEGER,              INTENT( IN ) :: NumTopBnc, NumBotBnc
    REAL    ( KIND = 8 ), INTENT( IN ) :: omega, Amp, Phase, SrcAngle, RcvrAngle
    COMPLEX ( KIND = 8 ), INTENT( IN ) :: delay
    LOGICAL              :: NewRay
    INTEGER              :: iArr( 1 ), id, ir, Nt
    REAL                 :: AmpTot, w1, w2
    
    Nt     = NArr( id, ir )    ! # of arrivals
    NewRay = .TRUE.

    ! Is this the second bracketting ray of a pair?
    ! If so, we want to combine the arrivals to conserve space.
    ! (test this by seeing if the arrival time is close to the previous one)
    ! (also need that the phase is about the same to make sure surface and direct paths are not joined)

    IF ( Nt >= 1 ) THEN
       IF ( omega * ABS( delay - Arr( id, ir, Nt )%delay ) < PhaseTol .AND. &
           ABS( Arr( id, ir, Nt )%phase - Phase )       < PhaseTol ) NewRay = .FALSE.
    END IF

    IF ( NewRay ) THEN
       IF ( Nt >= MaxNArr ) THEN       ! space available to add an arrival?
          iArr = MINLOC( Arr( id, ir, : )%A )                       ! no: replace weakest arrival
          IF ( Amp > Arr( id, ir, iArr( 1 ) )%A ) THEN
             Arr( id, ir, iArr( 1 ) )%A         = SNGL( Amp )       ! amplitude
             Arr( id, ir, iArr( 1 ) )%Phase     = SNGL( Phase )     ! phase
             Arr( id, ir, iArr( 1 ) )%delay     = CMPLX( delay )    ! delay time
             Arr( id, ir, iArr( 1 ) )%SrcAngle  = SNGL( SrcAngle )  ! angle
             Arr( id, ir, iArr( 1 ) )%RcvrAngle = SNGL( RcvrAngle ) ! angle
             Arr( id, ir, iArr( 1 ) )%NTopBnc   = NumTopBnc         ! Number of top     bounces
             Arr( id, ir, iArr( 1 ) )%NBotBnc   = NumBotBnc         !   "       bottom
          ENDIF
       ELSE
          NArr( id, ir         )           = Nt + 1              ! # of arrivals
          Arr(  id, ir, Nt + 1 )%A         = SNGL( Amp )         ! amplitude
          Arr(  id, ir, Nt + 1 )%Phase     = SNGL( Phase )       ! phase
          Arr(  id, ir, Nt + 1 )%delay     = CMPLX( delay )      ! delay time
          Arr(  id, ir, Nt + 1 )%SrcAngle  = SNGL( SrcAngle )    ! angle
          Arr(  id, ir, Nt + 1 )%RcvrAngle = SNGL( RcvrAngle )   ! angle
          Arr(  id, ir, Nt + 1 )%NTopBnc   = NumTopBnc           ! Number of top     bounces
          Arr(  id, ir, Nt + 1 )%NBotBnc   = NumBotBnc           !   "       bottom
       ENDIF
    ELSE      ! not a new ray
       !PhaseArr(   id, ir, Nt ) = PhaseArr( id, ir, Nt )

       ! calculate weightings of old ray information vs. new, based on amplitude of the arrival
       AmpTot = Arr( id, ir, Nt )%A + SNGL( Amp )
       w1     = Arr( id, ir, Nt )%A / AmpTot
       w2     = REAL( Amp ) / AmpTot

       Arr( id, ir, Nt )%delay     = w1 * Arr( id, ir, Nt )%delay     + w2 * CMPLX( delay ) ! weighted sum
       Arr( id, ir, Nt )%A         = AmpTot
       Arr( id, ir, Nt )%SrcAngle  = w1 * Arr( id, ir, Nt )%SrcAngle  + w2 * SNGL( SrcAngle  )
       Arr( id, ir, Nt )%RcvrAngle = w1 * Arr( id, ir, Nt )%RcvrAngle + w2 * SNGL( RcvrAngle )
    ENDIF

    RETURN
  END SUBROUTINE AddArr

  ! **********************************************************************!

  SUBROUTINE WriteArrivalsASCII( r, Nrd, Nr, SourceType )

    ! Writes the arrival data (Amplitude, delay for each eigenray)
    ! ASCII output file

    REAL,               PARAMETER   :: pi = 3.14159265, RadDeg = 180 / pi
    INTEGER,           INTENT( IN ) :: Nrd, Nr
    REAL,              INTENT( IN ) :: r( Nr )
    CHARACTER (LEN=1), INTENT( IN ) :: SourceType
    INTEGER           :: ir, id, iArr
    REAL              :: AArrT
    REAL     (KIND=8) :: factor

    WRITE( ARRFile, * ) MAXVAL( NArr( 1 : Nrd, 1 : Nr ) )

    DO id = 1, Nrd
       DO ir = 1, Nr
          IF ( SourceType == 'X' ) THEN   ! line source
             factor =  4.0 * SQRT( pi )
          ELSE                            ! point source
             IF ( r ( ir ) == 0 ) THEN
                factor = 1e5                   ! avoid /0 at origin
             ELSE
                factor = 1. / SQRT( r( ir ) )  ! cyl. spreading
             END IF
          END IF

          WRITE( ARRFile, * ) NArr( id, ir )
          DO iArr = 1, NArr( id, ir )
             AArrT = SNGL( factor * Arr( id, ir, iArr )%A )
             ! you can compress the output file a lot by putting in an explicit format statement here ...
             ! However, you'll need to make sure you keep adequate precision
             WRITE( ARRFile, * ) AArrT, &
                    RadDeg * Arr( id, ir, iArr )%Phase, &
                       REAL( Arr( id, ir, iArr )%delay ),  AIMAG( Arr( id, ir, iArr )%delay ),    &
                             Arr( id, ir, iArr )%SrcAngle, Arr( id, ir, iArr )%RcvrAngle, &
                             Arr( id, ir, iArr )%NTopBnc,  Arr( id, ir, iArr )%NBotBnc
          END DO  ! next arrival
       END DO  ! next receiver depth
    END DO  ! next range

    RETURN
  END SUBROUTINE WriteArrivalsASCII

  ! **********************************************************************!

  SUBROUTINE WriteArrivalsBinary( r, Nrd, Nr, SourceType )

    ! Writes the arrival data (amplitude, delay for each eigenray)
    ! Binary output file

    REAL,              PARAMETER    :: pi = 3.14159265, RadDeg = 180 / pi
    INTEGER,           INTENT( IN ) :: Nrd, Nr
    REAL,              INTENT( IN ) :: r( Nr )
    CHARACTER (LEN=1), INTENT( IN ) :: SourceType
    INTEGER           :: ir, id, iArr
    REAL              :: AArrT
    REAL     (KIND=8) :: factor

    WRITE( ARRFile ) MAXVAL( NArr( 1 : Nrd, 1 : Nr ) )

    DO id = 1, Nrd
       DO ir = 1, Nr
          IF ( SourceType == 'X' ) THEN   ! line source
             factor = 4.0 * SQRT( pi )
          ELSE                            ! point source
             IF ( r ( ir ) == 0 ) THEN
                factor = 1e5       ! avoid /0 at origin
             ELSE
                factor = 1. / SQRT( r( ir ) )  ! vol. atten. and cyl. spreading
             END IF
          END IF

          WRITE( ARRFile ) NArr( id, ir )

          DO iArr = 1, NArr( id, ir )
             AArrT = SNGL( factor * Arr( id, ir, iArr )%A )
             ! integers written out as reals below for fast reading in Matlab
             WRITE( ARRFile ) AArrT, RadDeg * Arr( id, ir, iArr )%Phase,           Arr( id, ir, iArr )%delay,      &
                                              Arr( id, ir, iArr )%SrcAngle,        Arr( id, ir, iArr )%RcvrAngle,  &
                                        REAL( Arr( id, ir, iArr )%NTopBnc ), REAL( Arr( id, ir, iArr )%NBotBnc )
          END DO   ! next arrival
       END DO   ! next receiver depth
    END DO   ! next range

    RETURN
  END SUBROUTINE WriteArrivalsBinary

  ! **********************************************************************!

  SUBROUTINE AddArr3D( omega, itheta, id, ir, Amp, Phase, delay, SrcAngle, RcvrAngle, NumTopBnc, NumBotBnc )

    ! ADDs the amplitude and delay for an ARRival into a matrix of same.
    ! Extra logic included to keep only the strongest arrivals.

    REAL,                  PARAMETER   :: PhaseTol = 0.5  ! arrivals with essentially the same phase are grouped into one
    INTEGER,              INTENT( IN ) :: itheta, id, ir
    INTEGER,              INTENT( IN ) :: NumTopBnc, NumBotBnc
    REAL    ( KIND = 8 ), INTENT( IN ) :: omega, Amp, Phase, SrcAngle, RcvrAngle
    COMPLEX ( KIND = 8 ), INTENT( IN ) :: delay
    LOGICAL              :: NewRay
    INTEGER              :: iArr( 1 ), Nt
    REAL                 :: AmpTot, w1, w2

    Nt     = NArr3D( itheta, id, ir )    ! # of arrivals
    NewRay = .TRUE.

    ! Is this the second bracketting ray of a pair?
    ! If so, we want to combine the arrivals to conserve space.
    ! (test this by seeing if the arrival time is close to the previous one)
    ! (also need that the phase is about the same to make sure surface and direct paths are not joined)

    IF ( Nt >= 1 ) THEN
       IF ( omega * ABS( delay - Arr3D( itheta,  id, ir, Nt )%delay ) < PhaseTol .AND. &
           ABS( Arr3D( itheta,  id, ir, Nt )%phase - Phase )       < PhaseTol ) NewRay = .FALSE.
    END IF

    IF ( NewRay ) THEN
       IF ( Nt >= MaxNArr ) THEN       ! space available to add an arrival?
          iArr = MINLOC( Arr3D( itheta,  id, ir, : )%A )                       ! no: replace weakest arrival
          IF ( Amp > Arr3D( itheta,  id, ir, iArr( 1 ) )%A ) THEN
             Arr3D( itheta,  id, ir, iArr( 1 ) )%A         = SNGL( Amp )       ! amplitude
             Arr3D( itheta,  id, ir, iArr( 1 ) )%Phase     = SNGL( Phase )     ! phase
             Arr3D( itheta,  id, ir, iArr( 1 ) )%delay     = CMPLX( delay )    ! delay time
             Arr3D( itheta,  id, ir, iArr( 1 ) )%SrcAngle  = SNGL( SrcAngle )  ! angle
             Arr3D( itheta,  id, ir, iArr( 1 ) )%RcvrAngle = SNGL( RcvrAngle ) ! angle
             Arr3D( itheta,  id, ir, iArr( 1 ) )%NTopBnc   = NumTopBnc         ! Number of top     bounces
             Arr3D( itheta,  id, ir, iArr( 1 ) )%NBotBnc   = NumBotBnc         !   "       bottom
          ENDIF
       ELSE
          NArr3D( itheta,  id, ir         )           = Nt + 1              ! # of arrivals
          Arr3D( itheta,   id, ir, Nt + 1 )%A         = SNGL( Amp )         ! amplitude
          Arr3D( itheta,   id, ir, Nt + 1 )%Phase     = SNGL( Phase )       ! phase
          Arr3D( itheta,   id, ir, Nt + 1 )%delay     = CMPLX( delay )      ! delay time
          Arr3D( itheta,   id, ir, Nt + 1 )%SrcAngle  = SNGL( SrcAngle )    ! angle
          Arr3D( itheta,   id, ir, Nt + 1 )%RcvrAngle = SNGL( RcvrAngle )   ! angle
          Arr3D( itheta,   id, ir, Nt + 1 )%NTopBnc   = NumTopBnc           ! Number of top     bounces
          Arr3D( itheta,   id, ir, Nt + 1 )%NBotBnc   = NumBotBnc           !   "       bottom
       ENDIF
    ELSE      ! not a new ray
       !PhaseArr(   id, ir, Nt ) = PhaseArr( id, ir, Nt )
       ! calculate weightings of old ray information vs. new, based on amplitude of the arrival
       AmpTot = Arr3D( itheta, id, ir, Nt )%A + SNGL( Amp )
       w1     = Arr3D( itheta, id, ir, Nt )%A / AmpTot
       w2     = REAL( Amp ) / AmpTot

       Arr3D( itheta, id, ir, Nt )%delay     = w1 * Arr3D( itheta, id, ir, Nt )%delay     + w2 * CMPLX( delay ) ! weighted sum
       Arr3D( itheta, id, ir, Nt )%A         = AmpTot
       Arr3D( itheta, id, ir, Nt )%SrcAngle  = w1 * Arr3D( itheta, id, ir, Nt )%SrcAngle  + w2 * SNGL( SrcAngle )
       Arr3D( itheta, id, ir, Nt )%RcvrAngle = w1 * Arr3D( itheta, id, ir, Nt )%RcvrAngle + w2 * SNGL( RcvrAngle )
    ENDIF

    RETURN
  END SUBROUTINE AddArr3D

  ! **********************************************************************!

  SUBROUTINE WriteArrivalsASCII3D( r, Ntheta, Nrd, Nr, SourceType )

    ! Writes the arrival data (Amplitude, delay for each eigenray)
    ! ASCII output file

    REAL,              PARAMETER    :: pi = 3.14159265, RadDeg = 180 / pi
    INTEGER,           INTENT( IN ) :: Ntheta, Nrd, Nr
    REAL,              INTENT( IN ) :: r( Nr )
    CHARACTER (LEN=1), INTENT( IN ) :: SourceType
    INTEGER           :: itheta, ir, id, iArr
    REAL     (KIND=8) :: factor
    REAL              :: AArrT

    WRITE( ARRFile, * ) MAXVAL( NArr3D( 1 : Ntheta,  1 : Nrd, 1 : Nr ) )

    DO itheta = 1, Ntheta
       DO id = 1, Nrd
          DO ir = 1, Nr
             IF ( SourceType == 'X' ) THEN   ! line source
                factor =  4.0 * SQRT( pi )
             ELSE                            ! point source
                IF ( r ( ir ) == 0 ) THEN
                   factor = 1e5       ! avoid /0 at origin
                ELSE
                   factor = 1. / SQRT( r( ir ) )  ! vol. atten. and cyl. spreading
                END IF
             END IF

             WRITE( ARRFile, * ) NArr3D( itheta,  id, ir )
             DO iArr = 1, NArr3D( itheta,  id, ir )
                AArrT = SNGL( factor * Arr3D( itheta,  id, ir, iArr )%A )
                ! you can compress the output file a lot by putting in an explicit format statement here ...
                ! However, you'll need to make sure you keep adequate precision
                WRITE( ARRFile, * ) AArrT,   &
                     RadDeg * Arr3D( itheta, id, ir, iArr )%Phase,     &
                              REAL( Arr3D( itheta, id, ir, iArr )%delay ),  AIMAG( Arr3D( itheta, id, ir, iArr )%delay ),    &
                              Arr3D( itheta, id, ir, iArr )%SrcAngle,  &
                              Arr3D( itheta, id, ir, iArr )%RcvrAngle, &
                              Arr3D( itheta, id, ir, iArr )%NTopBnc,   &
                              Arr3D( itheta, id, ir, iArr )%NBotBnc
             END DO  ! next arrival
          END DO  ! next receiver depth
       END DO  ! next range
    END DO   ! next angle

    RETURN
  END SUBROUTINE WriteArrivalsASCII3D

  ! **********************************************************************!

  SUBROUTINE WriteArrivalsBinary3D( r, Ntheta, Nrd, Nr, SourceType )

    ! Writes the arrival data (amplitude, delay for each eigenray)
    ! Binary output file

    REAL,              PARAMETER    :: pi = 3.14159265, RadDeg = 180 / pi
    INTEGER,           INTENT( IN ) :: Ntheta, Nrd, Nr
    REAL,              INTENT( IN ) :: r( Nr )
    CHARACTER (LEN=1), INTENT( IN ) :: SourceType
    INTEGER           :: itheta, ir, id, iArr
    REAL     (KIND=8) :: factor
    REAL              :: AArrT
    
    WRITE( ARRFile ) MAXVAL( NArr3D( 1 : Ntheta,  1 : Nrd, 1 : Nr ) )

    DO itheta = 1, Ntheta
       DO id = 1, Nrd
          DO ir = 1, Nr
             IF ( SourceType == 'X' ) THEN   ! line source
                factor = 4.0 * SQRT( pi )
             ELSE                            ! point source
                IF ( r ( ir ) == 0 ) THEN
                   factor = 1e5       ! avoid /0 at origin
                ELSE
                   factor = 1. / SQRT( r( ir ) )  ! vol. atten. and cyl. spreading
                END IF
             END IF

             WRITE( ARRFile ) NArr3D( itheta,  id, ir )

             DO iArr = 1, NArr3D( itheta,  id, ir )
                AArrT = SNGL( factor * Arr3D( itheta,  id, ir, iArr )%A )
                ! integers written out as reals below for fast reading in Matlab
                WRITE( ARRFile ) AArrT,   &
                     RadDeg * Arr3D( itheta,  id, ir, iArr )%Phase,     &
                              Arr3D( itheta,  id, ir, iArr )%delay,     &
                              Arr3D( itheta,  id, ir, iArr )%SrcAngle,  &
                              Arr3D( itheta,  id, ir, iArr )%RcvrAngle, &
                        REAL( Arr3D( itheta,  id, ir, iArr )%NTopBnc ), &
                        REAL( Arr3D( itheta,  id, ir, iArr )%NBotBnc )
             END DO   ! next arrival
          END DO   ! next receiver depth
       END DO   ! next range
    END DO   ! next angle

    RETURN
  END SUBROUTINE WriteArrivalsBinary3D

END MODULE ArrMod
