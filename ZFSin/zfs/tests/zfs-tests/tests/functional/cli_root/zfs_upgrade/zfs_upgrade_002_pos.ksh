#!/usr/bin/env ksh -p
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#

#
# Copyright 2007 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#
#
. $STF_SUITE/include/libtest.shlib
. $STF_SUITE/tests/functional/cli_root/zfs_upgrade/zfs_upgrade.kshlib

#
# DESCRIPTION:
#	Executing 'zfs upgrade -v ' command succeeds, it should
#	show the info of available versions.
#
# STRATEGY:
# 1. Execute 'zfs upgrade -v', verify return value is 0.
# 2, Verify all the available versions info are printed out.
#

verify_runnable "both"

function cleanup
{
	if [[ -f $output ]]; then
		log_must $RM -f $output
	fi
}

log_assert "Executing 'zfs upgrade -v' command succeeds."
log_onexit cleanup

typeset output=/tmp/zfs-versions.$$
typeset expect_str1="Initial ZFS filesystem version"
typeset expect_str2="Enhanced directory entries"

log_must eval '$ZFS upgrade -v > /dev/null 2>&1'

$ZFS upgrade -v | $AWK '$1 ~ "^[0-9]+$" {print $0}'> $output
log_must eval '$GREP "${expect_str1}" $output > /dev/null 2>&1'
log_must eval '$GREP "${expect_str2}" $output > /dev/null 2>&1'

log_pass "Executing 'zfs upgrade -v' command succeeds."
