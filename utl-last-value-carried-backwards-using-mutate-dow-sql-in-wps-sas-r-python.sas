%let pgm=utl-last-value-carried-backwards-using-mutate-dow-sql-in-wps-sas-r-python;

Last value carried backwards using mutate dow sql in wps sas r python

github
https://tinyurl.com/3f5kw9t3
https://github.com/rogerjdeangelis/utl-last-value-carried-backwards-using-mutate-dow-sql-in-wps-sas-r-python

  SOLUTIONS

       1 wps/sas sql
       2 wps/sas dow1  (without last.last.alg_vt1)
       3 wps/sas dow2  (with last.last.alg_vt1)
       4 R mutate1  (mutate is a fundamental function in r)
         https://stackoverflow.com/users/4821142/till
       5 R mutate2  (mutate is a fundamental function in r)
       6 R sql
       7 Python sql

https://stackoverflow.com/questions/76639273/conditionally-mutate-existing-values-by-group-r

libname sd1 "d:/sd1";
options validvarname=upcase;
data sd1.have(drop=ALG_VT2);informat
BP $3.
ID 8.
ALG_VT1 $1.
ALG_VT2 $1.
;input
BP ID ALG_VT1 ALG_VT2 V02;
cards4;
vt1 1 a a 18
vt2 1 a b 36
vt1 1 b a 16
vt2 1 b b 30
vt1 2 a a 19
vt2 2 a b 32
vt1 2 b a 10
vt2 2 b b 34
;;;;
run;quit;

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

/**************************************************************************************************************************/
/*                                                                                                                        */
/*                                           |  RULES (Add this variable)                                                 */
/*                                           |                                                                            */
/*  SD1.HAVE total obs=8 09MAY2023:17:11:09  |  Add colum V02_VT2                                                         */
/*                                           |                                                                            */
/*  Obs    BP     ID    ALG_VT1    V02 RULES |  V02_VT2                                                                   */
/*                                           |                                                                            */
/*   1     vt1     1       a        18 =>36  |     36   Last value of V02 carried backwards (overwrite first value)       */
/*   2     vt2     1       a        36       |     36                                                                     */
/*                                           |                                                                            */
/*   3     vt1     1       b        16 =>30  |     30   Last value of V02 carried backwards                               */
/*   4     vt2     1       b        30       |     30                                                                     */
/*                                           |                                                                            */
/*   5     vt1     2       a        19 =>32  |     32                                                                     */
/*   6     vt2     2       a        32       |     32                                                                     */
/*                                           |                                                                            */
/*   7     vt1     2       b        10 =>34  |     34                                                                     */
/*   8     vt2     2       b        34       |     34                                                                     */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                         __                         _
/ | __      ___ __  ___   / /__  __ _ ___   ___  __ _| |
| | \ \ /\ / / `_ \/ __| / / __|/ _` / __| / __|/ _` | |
| |  \ V  V /| |_) \__ \/ /\__ \ (_| \__ \ \__ \ (_| | |
|_|   \_/\_/ | .__/|___/_/ |___/\__,_|___/ |___/\__, |_|
             |_|                                   |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

proc sql;

  create
     table sd1.want as
  select
     l.bp
    ,l.id
    ,l.alg_vt1
    ,l.v02
    ,r.v02 as v02_vt2
  from
     sd1.have as l left join sd1.have(where=(bp="vt2")) as r
  on
          substr(l.bp,1,2)       = substr(r.bp,1,2)
     and  l.alg_vt1  = r.alg_vt1
     and  l.id       = r.id
  order by
     l.id
    ,l.ALG_VT1
    ,l.bp

;quit;
/*
__      ___ __  ___
\ \ /\ / / `_ \/ __|
 \ V  V /| |_) \__ \
  \_/\_/ | .__/|___/
         |_|
*/
proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

%utl_submit_wps64('

options validvarname=any;

libname sd1 "d:/sd1";

proc sql;

  create
     table sd1.want as
  select
     l.bp
    ,l.id
    ,l.alg_vt1
    ,l.v02
    ,r.v02 as v02_vt2
  from
     sd1.have as l left join sd1.have(where=(bp="vt2")) as r
  on
          substr(l.bp,1,2)       = substr(r.bp,1,2)
     and  l.alg_vt1  = r.alg_vt1
     and  l.id       = r.id
  order by
     l.id
    ,l.ALG_VT1
    ,l.bp

;quit;

proc print data=sd1.want;
run;quit;

');

/**************************************************************************************************************************/
/*                                                                                                                        */
/* The WPS System                                                                                                         */
/*                                                                                                                        */
/* Obs    BP     ID    ALG_VT1    V02    v02_vt2                                                                          */
/*                                                                                                                        */
/*  1     vt1     1       a        18       36                                                                            */
/*  2     vt2     1       a        36       36                                                                            */
/*  3     vt1     1       b        16       30                                                                            */
/*  4     vt2     1       b        30       30                                                                            */
/*  5     vt1     2       a        19       32                                                                            */
/*  6     vt2     2       a        32       32                                                                            */
/*  7     vt1     2       b        10       34                                                                            */
/*  8     vt2     2       b        34       34                                                                            */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                          __                   _               _
|___ \  __      ___ __  ___   / /__  __ _ ___    __| | _____      _/ |
  __) | \ \ /\ / / `_ \/ __| / / __|/ _` / __|  / _` |/ _ \ \ /\ / / |
 / __/   \ V  V /| |_) \__ \/ /\__ \ (_| \__ \ | (_| | (_) \ V  V /| |
|_____|   \_/\_/ | .__/|___/_/ |___/\__,_|___/  \__,_|\___/ \_/\_/ |_|
                 |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

data sd1.want ;
  do until (bp="vt2");
    set sd1.have;
    if bp="vt2" then vo2_vt2=v02;
  end;
  do until (bp="vt2");
    set sd1.have;
    output;
  end;
run;quit;

/*
__      ___ __  ___
\ \ /\ / / `_ \/ __|
 \ V  V /| |_) \__ \
  \_/\_/ | .__/|___/
         |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

%utl_submit_wps64('

libname sd1 "d:/sd1";

data sd1.want ;
  do until (bp="vt2");
    set sd1.have;
    if bp="vt2" then vo2_vt2=v02;
  end;
  do until (bp="vt2");
    set sd1.have;
    output;
  end;
run;quit;

proc print data=sd1.want;
run;quit;

');


/**************************************************************************************************************************/
/*                                                                                                                        */
/* The WPS System                                                                                                         */
/*                                                                                                                        */
/* Obs    BP     ID    ALG_VT1    V02    v02_vt2                                                                          */
/*                                                                                                                        */
/*  1     vt1     1       a        18       36                                                                            */
/*  2     vt2     1       a        36       36                                                                            */
/*  3     vt1     1       b        16       30                                                                            */
/*  4     vt2     1       b        30       30                                                                            */
/*  5     vt1     2       a        19       32                                                                            */
/*  6     vt2     2       a        32       32                                                                            */
/*  7     vt1     2       b        10       34                                                                            */
/*  8     vt2     2       b        34       34                                                                            */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                     __                   _               _____
__      ___ __  ___   / /__  __ _ ___    __| | _____      _|___ /
\ \ /\ / / `_ \/ __| / / __|/ _` / __|  / _` |/ _ \ \ /\ / / |_ \
 \ V  V /| |_) \__ \/ /\__ \ (_| \__ \ | (_| | (_) \ V  V / ___) |
  \_/\_/ | .__/|___/_/ |___/\__,_|___/  \__,_|\___/ \_/\_/ |____/
         |_|
*/


proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

data sd1.want;
  do until (last.alg_vt1);
      set sd1.have;
      by alg_vt1 notsorted;
  end;
  vo2_vt2=v02;
  do until (last.alg_vt1);
      set sd1.have;
      by alg_vt1 notsorted;
      output;
  end;
run;quit;

/*
__      ___ __  ___
\ \ /\ / / `_ \/ __|
 \ V  V /| |_) \__ \
  \_/\_/ | .__/|___/
         |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

%utl_submit_wps64('

libname sd1 "d:/sd1";

data sd1.want ;
  do until (last.alg_vt1);
      set sd1.have;
      by alg_vt1 notsorted;
  end;
  vo2_vt2=v02;
  do until (last.alg_vt1);
      set sd1.have;
      by alg_vt1 notsorted;
      output;
  end;
run;quit;

proc print data=sd1.want;
run;quit;

');


/**************************************************************************************************************************/
/*                                                                                                                        */
/* The WPS System                                                                                                         */
/*                                                                                                                        */
/* Obs    BP     ID    ALG_VT1    V02    v02_vt2                                                                          */
/*                                                                                                                        */
/*  1     vt1     1       a        18       36                                                                            */
/*  2     vt2     1       a        36       36                                                                            */
/*  3     vt1     1       b        16       30                                                                            */
/*  4     vt2     1       b        30       30                                                                            */
/*  5     vt1     2       a        19       32                                                                            */
/*  6     vt2     2       a        32       32                                                                            */
/*  7     vt1     2       b        10       34                                                                            */
/*  8     vt2     2       b        34       34                                                                            */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*  _                            _        _        _
| || |    _ __   _ __ ___  _   _| |_ __ _| |_ ___ / |
| || |_  | `__| | `_ ` _ \| | | | __/ _` | __/ _ \| |
|__   _| | |    | | | | | | |_| | || (_| | ||  __/| |
   |_|   |_|    |_| |_| |_|\__,_|\__\__,_|\__\___||_|

*/

proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

%utl_submit_wps64x('
libname sd1 "d:/sd1";
proc r;
export data=sd1.have r=df;
submit;
library(tidyverse);
df |>
  mutate(V02_VT2 = ifelse(BP == "vt1", NA, V02)) |>
  fill(V02_VT2, .direction = "up");
endsubmit;
run;quit;
');
/*___                           _        _       ____
| ___|   _ __   _ __ ___  _   _| |_ __ _| |_ ___|___ \
|___ \  | `__| | `_ ` _ \| | | | __/ _` | __/ _ \ __) |
 ___) | | |    | | | | | | |_| | || (_| | ||  __// __/
|____/  |_|    |_| |_| |_|\__,_|\__\__,_|\__\___|_____|

*/
proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

%utl_submit_wps64x('
libname sd1 "d:/sd1";
proc r;
export data=sd1.have r=df;
submit;
library(tidyverse);
df<-as_tibble(df);
df %>% mutate(V02 = if_else(BP == "vt2", NA, V02));
want <- df %>% mutate(V02_VT2=max(V02, na.rm=T), .by=c(ID,ALG_VT1));
want;
endsubmit;
import data=sd1.want r=want;
');

proc print data=sd1.want;
run;quit;

/*__                      _
 / /_    _ __   ___  __ _| |
| `_ \  | `__| / __|/ _` | |
| (_) | | |    \__ \ (_| | |
 \___/  |_|    |___/\__, |_|
                       |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

%utl_submit_wps64x('
libname sd1 "d:/sd1";
proc r;
export data=sd1.have r=have;
submit;
library(sqldf);
want<-sqldf("
  select
     l.bp
    ,l.id
    ,l.alg_vt1
    ,l.v02
    ,r.v02 as v02_vt2
  from
     have as l left join have as r
  on
          substr(l.bp,1,2)       = substr(r.bp,1,2)
     and  l.alg_vt1  = r.alg_vt1
     and  l.id       = r.id
 where
     r.bp=\"vt2\"
  order by
     l.id
    ,l.alg_vt1
    ,l.bp
;");
want;
endsubmit;
import data=sd1.want r=want;
run;quit;

proc print data=sd1.want;
run;quit;
');

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  The WPS System                                                                                                        */
/*                                                                                                                        */
/*  Obs    BP     ID    ALG_VT1    V02    V02_VT2                                                                         */
/*                                                                                                                        */
/*   1     vt1     1       a        18       36                                                                           */
/*   2     vt2     1       a        36       36                                                                           */
/*   3     vt1     1       b        16       30                                                                           */
/*   4     vt2     1       b        30       30                                                                           */
/*   5     vt1     2       a        19       32                                                                           */
/*   6     vt2     2       a        32       32                                                                           */
/*   7     vt1     2       b        10       34                                                                           */
/*   8     vt2     2       b        34       34                                                                           */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*____               _   _                             _
|___  |  _ __  _   _| |_| |__   ___  _ __    ___  __ _| |
   / /  | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | |
  / /   | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | |
 /_/    | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_|
        |_|    |___/                                |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

%utl_submit_wps64x('
libname sd1 "d:/sd1";
proc python;
export data=sd1.have python=have;
submit;
from os import path;
import pandas as pd;
import numpy as np;
import pandas as pd;
from pandasql import sqldf;
mysql = lambda q: sqldf(q, globals());
from pandasql import PandaSQL;
pdsql = PandaSQL(persist=True);
sqlite3conn = next(pdsql.conn.gen).connection.connection;
sqlite3conn.enable_load_extension(True);
sqlite3conn.load_extension("c:/temp/libsqlitefunctions.dll");
mysql = lambda q: sqldf(q, globals());
want = pdsql("""
  select
     l.bp
    ,l.id
    ,l.alg_vt1
    ,l.v02
    ,r.v02 as v02_vt2
  from
     have as l left join have as r
  on
          substr(l.bp,1,2)       = substr(r.bp,1,2)
     and  l.alg_vt1  = r.alg_vt1
     and  l.id       = r.id
 where
     r.bp=\"vt2\"
  order by
     l.id
    ,l.alg_vt1
    ,l.bp
""");
print(want);
endsubmit;
import data=sd1.want python=want;
run;quit;

proc print data=sd1.want;
run;quit;
');

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  The WPS System                                                                                                        */
/*                                                                                                                        */
/*  Obs    BP     ID    ALG_VT1    V02    V02_VT2                                                                         */
/*                                                                                                                        */
/*   1     vt1     1       a        18       36                                                                           */
/*   2     vt2     1       a        36       36                                                                           */
/*   3     vt1     1       b        16       30                                                                           */
/*   4     vt2     1       b        30       30                                                                           */
/*   5     vt1     2       a        19       32                                                                           */
/*   6     vt2     2       a        32       32                                                                           */
/*   7     vt1     2       b        10       34                                                                           */
/*   8     vt2     2       b        34       34                                                                           */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
