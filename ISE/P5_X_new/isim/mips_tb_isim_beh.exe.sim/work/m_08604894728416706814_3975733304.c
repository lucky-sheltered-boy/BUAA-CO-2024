/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0xfbc00daa */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/media/shared/share/ISE/P5_X_new/CP0.v";
static int ng1[] = {0, 0};
static unsigned int ng2[] = {12U, 0U};
static int ng3[] = {1, 0};
static unsigned int ng4[] = {13U, 0U};
static int ng5[] = {6, 0};
static int ng6[] = {2, 0};
static unsigned int ng7[] = {14U, 0U};
static unsigned int ng8[] = {0U, 0U};
static unsigned int ng9[] = {1U, 0U};



static void Always_40_0(char *t0)
{
    char t13[8];
    char t40[8];
    char t49[8];
    char t57[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    char *t12;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    char *t21;
    char *t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    char *t28;
    char *t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    unsigned int t34;
    char *t35;
    char *t36;
    int t37;
    char *t38;
    char *t39;
    char *t41;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    unsigned int t46;
    unsigned int t47;
    char *t48;
    char *t50;
    char *t51;
    char *t52;
    char *t53;
    char *t54;
    unsigned int t55;
    int t56;
    int t58;
    int t59;
    int t60;
    int t61;
    int t62;
    int t63;
    int t64;
    unsigned int t65;
    unsigned int t66;
    unsigned int t67;
    unsigned int t68;
    unsigned int t69;
    unsigned int t70;
    unsigned int t71;
    unsigned int t72;
    unsigned int t73;
    unsigned int t74;
    unsigned int t75;

LAB0:    t1 = (t0 + 4280U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(40, ng0);
    t2 = (t0 + 5344);
    *((int *)t2) = 1;
    t3 = (t0 + 4312);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(40, ng0);

LAB5:    xsi_set_current_line(41, ng0);
    t4 = (t0 + 1208U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(45, ng0);

LAB10:    xsi_set_current_line(46, ng0);
    t2 = (t0 + 2888);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng1)));
    memset(t13, 0, 8);
    t11 = (t4 + 4);
    t12 = (t5 + 4);
    t6 = *((unsigned int *)t4);
    t7 = *((unsigned int *)t5);
    t8 = (t6 ^ t7);
    t9 = *((unsigned int *)t11);
    t10 = *((unsigned int *)t12);
    t14 = (t9 ^ t10);
    t15 = (t8 | t14);
    t16 = *((unsigned int *)t11);
    t17 = *((unsigned int *)t12);
    t18 = (t16 | t17);
    t19 = (~(t18));
    t20 = (t15 & t19);
    if (t20 != 0)
        goto LAB14;

LAB11:    if (t18 != 0)
        goto LAB13;

LAB12:    *((unsigned int *)t13) = 1;

LAB14:    t22 = (t13 + 4);
    t23 = *((unsigned int *)t22);
    t24 = (~(t23));
    t25 = *((unsigned int *)t13);
    t26 = (t25 & t24);
    t27 = (t26 != 0);
    if (t27 > 0)
        goto LAB15;

LAB16:
LAB17:    xsi_set_current_line(62, ng0);
    t2 = (t0 + 3048);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t13, 0, 8);
    t5 = (t13 + 4);
    t11 = (t4 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (t6 >> 1);
    t8 = (t7 & 1);
    *((unsigned int *)t13) = t8;
    t9 = *((unsigned int *)t11);
    t10 = (t9 >> 1);
    t14 = (t10 & 1);
    *((unsigned int *)t5) = t14;
    t12 = ((char*)((ng8)));
    memset(t40, 0, 8);
    t21 = (t13 + 4);
    t22 = (t12 + 4);
    t15 = *((unsigned int *)t13);
    t16 = *((unsigned int *)t12);
    t17 = (t15 ^ t16);
    t18 = *((unsigned int *)t21);
    t19 = *((unsigned int *)t22);
    t20 = (t18 ^ t19);
    t23 = (t17 | t20);
    t24 = *((unsigned int *)t21);
    t25 = *((unsigned int *)t22);
    t26 = (t24 | t25);
    t27 = (~(t26));
    t30 = (t23 & t27);
    if (t30 != 0)
        goto LAB41;

LAB38:    if (t26 != 0)
        goto LAB40;

LAB39:    *((unsigned int *)t40) = 1;

LAB41:    t29 = (t40 + 4);
    t31 = *((unsigned int *)t29);
    t32 = (~(t31));
    t33 = *((unsigned int *)t40);
    t34 = (t33 & t32);
    t42 = (t34 != 0);
    if (t42 > 0)
        goto LAB42;

LAB43:    xsi_set_current_line(68, ng0);

LAB58:    xsi_set_current_line(69, ng0);
    t2 = (t0 + 2168U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB59;

LAB60:
LAB61:
LAB44:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(41, ng0);

LAB9:    xsi_set_current_line(42, ng0);
    t11 = ((char*)((ng1)));
    t12 = (t0 + 3048);
    xsi_vlogvar_wait_assign_value(t12, t11, 0, 0, 32, 0LL);
    xsi_set_current_line(43, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3208);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 32, 0LL);
    xsi_set_current_line(44, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3368);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 32, 0LL);
    goto LAB8;

LAB13:    t21 = (t13 + 4);
    *((unsigned int *)t13) = 1;
    *((unsigned int *)t21) = 1;
    goto LAB14;

LAB15:    xsi_set_current_line(46, ng0);

LAB18:    xsi_set_current_line(47, ng0);
    t28 = (t0 + 1368U);
    t29 = *((char **)t28);
    t28 = (t29 + 4);
    t30 = *((unsigned int *)t28);
    t31 = (~(t30));
    t32 = *((unsigned int *)t29);
    t33 = (t32 & t31);
    t34 = (t33 != 0);
    if (t34 > 0)
        goto LAB19;

LAB20:
LAB21:    goto LAB17;

LAB19:    xsi_set_current_line(47, ng0);

LAB22:    xsi_set_current_line(48, ng0);
    t35 = (t0 + 1528U);
    t36 = *((char **)t35);

LAB23:    t35 = ((char*)((ng2)));
    t37 = xsi_vlog_unsigned_case_compare(t36, 5, t35, 5);
    if (t37 == 1)
        goto LAB24;

LAB25:    t2 = ((char*)((ng4)));
    t37 = xsi_vlog_unsigned_case_compare(t36, 5, t2, 5);
    if (t37 == 1)
        goto LAB26;

LAB27:    t2 = ((char*)((ng7)));
    t37 = xsi_vlog_unsigned_case_compare(t36, 5, t2, 5);
    if (t37 == 1)
        goto LAB28;

LAB29:
LAB30:    goto LAB21;

LAB24:    xsi_set_current_line(49, ng0);

LAB31:    xsi_set_current_line(50, ng0);
    t38 = (t0 + 1688U);
    t39 = *((char **)t38);
    memset(t40, 0, 8);
    t38 = (t40 + 4);
    t41 = (t39 + 4);
    t42 = *((unsigned int *)t39);
    t43 = (t42 >> 1);
    t44 = (t43 & 1);
    *((unsigned int *)t40) = t44;
    t45 = *((unsigned int *)t41);
    t46 = (t45 >> 1);
    t47 = (t46 & 1);
    *((unsigned int *)t38) = t47;
    t48 = (t0 + 3048);
    t50 = (t0 + 3048);
    t51 = (t50 + 72U);
    t52 = *((char **)t51);
    t53 = ((char*)((ng3)));
    xsi_vlog_generic_convert_bit_index(t49, t52, 2, t53, 32, 1);
    t54 = (t49 + 4);
    t55 = *((unsigned int *)t54);
    t56 = (!(t55));
    if (t56 == 1)
        goto LAB32;

LAB33:    goto LAB30;

LAB26:    xsi_set_current_line(52, ng0);

LAB34:    xsi_set_current_line(53, ng0);
    t3 = (t0 + 1688U);
    t4 = *((char **)t3);
    memset(t13, 0, 8);
    t3 = (t13 + 4);
    t5 = (t4 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (t6 >> 2);
    *((unsigned int *)t13) = t7;
    t8 = *((unsigned int *)t5);
    t9 = (t8 >> 2);
    *((unsigned int *)t3) = t9;
    t10 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t10 & 31U);
    t14 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t14 & 31U);
    t11 = (t0 + 3208);
    t12 = (t0 + 3208);
    t21 = (t12 + 72U);
    t22 = *((char **)t21);
    t28 = ((char*)((ng5)));
    t29 = ((char*)((ng6)));
    xsi_vlog_convert_partindices(t40, t49, t57, ((int*)(t22)), 2, t28, 32, 1, t29, 32, 1);
    t35 = (t40 + 4);
    t15 = *((unsigned int *)t35);
    t56 = (!(t15));
    t38 = (t49 + 4);
    t16 = *((unsigned int *)t38);
    t58 = (!(t16));
    t59 = (t56 && t58);
    t39 = (t57 + 4);
    t17 = *((unsigned int *)t39);
    t60 = (!(t17));
    t61 = (t59 && t60);
    if (t61 == 1)
        goto LAB35;

LAB36:    goto LAB30;

LAB28:    xsi_set_current_line(55, ng0);

LAB37:    xsi_set_current_line(56, ng0);
    t3 = (t0 + 1688U);
    t4 = *((char **)t3);
    t3 = (t0 + 3368);
    xsi_vlogvar_wait_assign_value(t3, t4, 0, 0, 32, 0LL);
    goto LAB30;

LAB32:    xsi_vlogvar_wait_assign_value(t48, t40, 0, *((unsigned int *)t49), 1, 0LL);
    goto LAB33;

LAB35:    t18 = *((unsigned int *)t57);
    t62 = (t18 + 0);
    t19 = *((unsigned int *)t40);
    t20 = *((unsigned int *)t49);
    t63 = (t19 - t20);
    t64 = (t63 + 1);
    xsi_vlogvar_wait_assign_value(t11, t13, t62, *((unsigned int *)t49), t64, 0LL);
    goto LAB36;

LAB40:    t28 = (t40 + 4);
    *((unsigned int *)t40) = 1;
    *((unsigned int *)t28) = 1;
    goto LAB41;

LAB42:    xsi_set_current_line(62, ng0);

LAB45:    xsi_set_current_line(63, ng0);
    t35 = (t0 + 2008U);
    t38 = *((char **)t35);
    t35 = ((char*)((ng8)));
    memset(t49, 0, 8);
    t39 = (t38 + 4);
    t41 = (t35 + 4);
    t43 = *((unsigned int *)t38);
    t44 = *((unsigned int *)t35);
    t45 = (t43 ^ t44);
    t46 = *((unsigned int *)t39);
    t47 = *((unsigned int *)t41);
    t55 = (t46 ^ t47);
    t65 = (t45 | t55);
    t66 = *((unsigned int *)t39);
    t67 = *((unsigned int *)t41);
    t68 = (t66 | t67);
    t69 = (~(t68));
    t70 = (t65 & t69);
    if (t70 != 0)
        goto LAB47;

LAB46:    if (t68 != 0)
        goto LAB48;

LAB49:    t50 = (t49 + 4);
    t71 = *((unsigned int *)t50);
    t72 = (~(t71));
    t73 = *((unsigned int *)t49);
    t74 = (t73 & t72);
    t75 = (t74 != 0);
    if (t75 > 0)
        goto LAB50;

LAB51:
LAB52:    goto LAB44;

LAB47:    *((unsigned int *)t49) = 1;
    goto LAB49;

LAB48:    t48 = (t49 + 4);
    *((unsigned int *)t49) = 1;
    *((unsigned int *)t48) = 1;
    goto LAB49;

LAB50:    xsi_set_current_line(63, ng0);

LAB53:    xsi_set_current_line(64, ng0);
    t51 = (t0 + 1848U);
    t52 = *((char **)t51);
    t51 = (t0 + 3368);
    xsi_vlogvar_wait_assign_value(t51, t52, 0, 0, 32, 0LL);
    xsi_set_current_line(65, ng0);
    t2 = ((char*)((ng9)));
    t3 = (t0 + 3048);
    t4 = (t0 + 3048);
    t5 = (t4 + 72U);
    t11 = *((char **)t5);
    t12 = ((char*)((ng3)));
    xsi_vlog_generic_convert_bit_index(t13, t11, 2, t12, 32, 1);
    t21 = (t13 + 4);
    t6 = *((unsigned int *)t21);
    t37 = (!(t6));
    if (t37 == 1)
        goto LAB54;

LAB55:    xsi_set_current_line(66, ng0);
    t2 = (t0 + 2008U);
    t3 = *((char **)t2);
    t2 = (t0 + 3208);
    t4 = (t0 + 3208);
    t5 = (t4 + 72U);
    t11 = *((char **)t5);
    t12 = ((char*)((ng5)));
    t21 = ((char*)((ng6)));
    xsi_vlog_convert_partindices(t13, t40, t49, ((int*)(t11)), 2, t12, 32, 1, t21, 32, 1);
    t22 = (t13 + 4);
    t6 = *((unsigned int *)t22);
    t37 = (!(t6));
    t28 = (t40 + 4);
    t7 = *((unsigned int *)t28);
    t56 = (!(t7));
    t58 = (t37 && t56);
    t29 = (t49 + 4);
    t8 = *((unsigned int *)t29);
    t59 = (!(t8));
    t60 = (t58 && t59);
    if (t60 == 1)
        goto LAB56;

LAB57:    goto LAB52;

LAB54:    xsi_vlogvar_wait_assign_value(t3, t2, 0, *((unsigned int *)t13), 1, 0LL);
    goto LAB55;

LAB56:    t9 = *((unsigned int *)t49);
    t61 = (t9 + 0);
    t10 = *((unsigned int *)t13);
    t14 = *((unsigned int *)t40);
    t62 = (t10 - t14);
    t63 = (t62 + 1);
    xsi_vlogvar_wait_assign_value(t2, t3, t61, *((unsigned int *)t40), t63, 0LL);
    goto LAB57;

LAB59:    xsi_set_current_line(69, ng0);

LAB62:    xsi_set_current_line(70, ng0);
    t4 = ((char*)((ng8)));
    t5 = (t0 + 3048);
    t11 = (t0 + 3048);
    t12 = (t11 + 72U);
    t21 = *((char **)t12);
    t22 = ((char*)((ng3)));
    xsi_vlog_generic_convert_bit_index(t13, t21, 2, t22, 32, 1);
    t28 = (t13 + 4);
    t14 = *((unsigned int *)t28);
    t37 = (!(t14));
    if (t37 == 1)
        goto LAB63;

LAB64:    goto LAB61;

LAB63:    xsi_vlogvar_wait_assign_value(t5, t4, 0, *((unsigned int *)t13), 1, 0LL);
    goto LAB64;

}

static void Always_76_1(char *t0)
{
    char t6[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t7;
    char *t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    char *t21;
    char *t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    char *t28;
    char *t29;

LAB0:    t1 = (t0 + 4528U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(76, ng0);
    t2 = (t0 + 5360);
    *((int *)t2) = 1;
    t3 = (t0 + 4560);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(76, ng0);

LAB5:    xsi_set_current_line(77, ng0);
    t4 = (t0 + 2008U);
    t5 = *((char **)t4);
    t4 = ((char*)((ng8)));
    memset(t6, 0, 8);
    t7 = (t5 + 4);
    t8 = (t4 + 4);
    t9 = *((unsigned int *)t5);
    t10 = *((unsigned int *)t4);
    t11 = (t9 ^ t10);
    t12 = *((unsigned int *)t7);
    t13 = *((unsigned int *)t8);
    t14 = (t12 ^ t13);
    t15 = (t11 | t14);
    t16 = *((unsigned int *)t7);
    t17 = *((unsigned int *)t8);
    t18 = (t16 | t17);
    t19 = (~(t18));
    t20 = (t15 & t19);
    if (t20 != 0)
        goto LAB7;

LAB6:    if (t18 != 0)
        goto LAB8;

LAB9:    t22 = (t6 + 4);
    t23 = *((unsigned int *)t22);
    t24 = (~(t23));
    t25 = *((unsigned int *)t6);
    t26 = (t25 & t24);
    t27 = (t26 != 0);
    if (t27 > 0)
        goto LAB10;

LAB11:    xsi_set_current_line(79, ng0);

LAB14:    xsi_set_current_line(80, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2888);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);

LAB12:    goto LAB2;

LAB7:    *((unsigned int *)t6) = 1;
    goto LAB9;

LAB8:    t21 = (t6 + 4);
    *((unsigned int *)t6) = 1;
    *((unsigned int *)t21) = 1;
    goto LAB9;

LAB10:    xsi_set_current_line(77, ng0);

LAB13:    xsi_set_current_line(78, ng0);
    t28 = ((char*)((ng3)));
    t29 = (t0 + 2888);
    xsi_vlogvar_assign_value(t29, t28, 0, 0, 1);
    goto LAB12;

}

static void Always_84_2(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    int t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;

LAB0:    t1 = (t0 + 4776U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(84, ng0);
    t2 = (t0 + 5376);
    *((int *)t2) = 1;
    t3 = (t0 + 4808);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(84, ng0);

LAB5:    xsi_set_current_line(85, ng0);
    t4 = (t0 + 1528U);
    t5 = *((char **)t4);

LAB6:    t4 = ((char*)((ng2)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 5, t4, 5);
    if (t6 == 1)
        goto LAB7;

LAB8:    t2 = ((char*)((ng4)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 5, t2, 5);
    if (t6 == 1)
        goto LAB9;

LAB10:    t2 = ((char*)((ng7)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 5, t2, 5);
    if (t6 == 1)
        goto LAB11;

LAB12:
LAB13:    goto LAB2;

LAB7:    xsi_set_current_line(86, ng0);

LAB14:    xsi_set_current_line(87, ng0);
    t7 = (t0 + 3048);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t10 = (t0 + 2728);
    xsi_vlogvar_assign_value(t10, t9, 0, 0, 32);
    goto LAB13;

LAB9:    xsi_set_current_line(89, ng0);

LAB15:    xsi_set_current_line(90, ng0);
    t3 = (t0 + 3208);
    t4 = (t3 + 56U);
    t7 = *((char **)t4);
    t8 = (t0 + 2728);
    xsi_vlogvar_assign_value(t8, t7, 0, 0, 32);
    goto LAB13;

LAB11:    xsi_set_current_line(92, ng0);

LAB16:    xsi_set_current_line(93, ng0);
    t3 = (t0 + 3368);
    t4 = (t3 + 56U);
    t7 = *((char **)t4);
    t8 = (t0 + 2728);
    xsi_vlogvar_assign_value(t8, t7, 0, 0, 32);
    goto LAB13;

}

static void Cont_98_3(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;

LAB0:    t1 = (t0 + 5024U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(98, ng0);
    t2 = (t0 + 3368);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 5472);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t4, 8);
    xsi_driver_vfirst_trans(t5, 0, 31);
    t10 = (t0 + 5392);
    *((int *)t10) = 1;

LAB1:    return;
}


extern void work_m_08604894728416706814_3975733304_init()
{
	static char *pe[] = {(void *)Always_40_0,(void *)Always_76_1,(void *)Always_84_2,(void *)Cont_98_3};
	xsi_register_didat("work_m_08604894728416706814_3975733304", "isim/mips_tb_isim_beh.exe.sim/work/m_08604894728416706814_3975733304.didat");
	xsi_register_executes(pe);
}
