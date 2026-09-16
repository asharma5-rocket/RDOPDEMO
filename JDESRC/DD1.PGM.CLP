/***************************************************************/
/*  Aldon Computer Group makes no warranty, express or         */
/*  implied, with regard to this material, including fitness   */
/*  for use.  Additionally, Aldon is not responsible for       */
/*  maintaining compatibility of this information with future  */
/*  releases.  Aldon provides this as an example only.         */
/*  Customers using this information do so at their own risk.  */
/***************************************************************/
/* Define as after each exit for promote and extract.          */
/* For promote calls JDE program P996301                       */
/* For extract copies F9816* files then calls P996301          */
/***************************************************************/

             PGM        PARM(&ACTCODE &TIMCODE &FILEREC &FILENAM +
                          &LIBNAM &CMPLCDE)

/*  Define parameters passed to this program.                  */

             DCL        VAR(&ACTCODE) TYPE(*CHAR) LEN(3)
             DCL        VAR(&TIMCODE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILEREC) TYPE(*CHAR) LEN(287)
             DCL        VAR(&FILENAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CMPLCDE) TYPE(*CHAR) LEN(1)

/*  Define exit file record parameters.                         */

             DCL        VAR(&GRP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJNAME) TYPE(*CHAR) LEN(128)
             DCL        VAR(&OBJTYPE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&OBJATTR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJEXTA) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FRMREL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FRMENV) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FRMSUBENV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FRMOBJLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FRMSRCLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOREL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOENV) TYPE(*CHAR) LEN(3)
             DCL        VAR(&TOSUBENV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOOBJLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOSRCLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PROJECT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EXITSTS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DD) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&GRP) VALUE(%SST(&FILEREC 1 10))
             CHGVAR     VAR(&PRD) VALUE(%SST(&FILEREC 11 10))
             CHGVAR     VAR(&OBJNAME) VALUE(%SST(&FILEREC 21 128))
             CHGVAR     VAR(&OBJTYPE) VALUE(%SST(&FILEREC 149 8))
             CHGVAR     VAR(&OBJATTR) VALUE(%SST(&FILEREC 157 10))
             CHGVAR     VAR(&OBJEXTA) VALUE(%SST(&FILEREC 167 3))
             CHGVAR     VAR(&FRMREL) VALUE(%SST(&FILEREC 170 10))
             CHGVAR     VAR(&FRMENV) VALUE(%SST(&FILEREC 180 3))
             CHGVAR     VAR(&FRMSUBENV) VALUE(%SST(&FILEREC 183 10))
             CHGVAR     VAR(&FRMOBJLIB) VALUE(%SST(&FILEREC 193 10))
             CHGVAR     VAR(&FRMSRCLIB) VALUE(%SST(&FILEREC 203 10))
             CHGVAR     VAR(&TOREL) VALUE(%SST(&FILEREC 213 10))
             CHGVAR     VAR(&TOENV) VALUE(%SST(&FILEREC 223 3))
             CHGVAR     VAR(&TOSUBENV) VALUE(%SST(&FILEREC 226 10))
             CHGVAR     VAR(&TOOBJLIB) VALUE(%SST(&FILEREC 236 10))
             CHGVAR     VAR(&TOSRCLIB) VALUE(%SST(&FILEREC 246 10))
             CHGVAR     VAR(&SRCF) VALUE(%SST(&FILEREC 256 10))
             CHGVAR     VAR(&SRCM) VALUE(%SST(&FILEREC 266 10))
             CHGVAR     VAR(&PROJECT) VALUE(%SST(&FILEREC 276 10))
             CHGVAR     VAR(&EXITSTS) VALUE(%SST(&FILEREC 286 2))

/* Perform exit processing only if the Aldon/CMS function     */
/* completed normally.                                        */
/* After exits test for EXITSTS = '00'                        */

             IF         COND(&EXITSTS *NE '00') THEN(GOTO +
                          CMDLBL(ENDPGM))

/* Test for Data Dictionary *RCDS                             */

             IF         COND(&OBJTYPE *EQ '*RCDS') THEN(DO)
               IF       COND(&OBJATTR *EQ 'DD') THEN(DO)
                 IF     COND(&ACTCODE *EQ 'EXT') THEN(DO)

/* Copy the required files to the extract library             */

             CRTDUPOBJ  OBJ(F9816*) FROMLIB(&FRMOBJLIB) +
                          OBJTYPE(*FILE) TOLIB(&TOOBJLIB)
             MONMSG     MSGID(CPF2130)
                 ENDDO

/* JDE object lib must be in JOBD library list (ACMSBATCH for EXT) */

             ADDLIBLE   LIB(JDFOBJ)
             MONMSG     MSGID(CPF2103)

/* Environment libraries are not in the library list for EXT       */

             ADDLIBLE   LIB(&FRMOBJLIB)
             MONMSG     MSGID(CPF2103)

/* Call JDE program to copy Data Dictionary element                */

             CHGVAR     VAR(&DD) VALUE(%SST(&OBJNAME 3 8))
             CALL       PGM(P996301) PARM(&FRMOBJLIB &TOOBJLIB &DD ' +
                          ' ' ' ' ' ' ')
               ENDDO
             ENDDO

/* Send completion code to ACMS                               */

             CHGVAR     VAR(&CMPLCDE) VALUE('0')

/*           DMPCLPGM                                         */

ENDPGM:
             ENDPGM
