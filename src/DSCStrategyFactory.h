/* 
 * Copyright 2014 Internet Corporation for Assigned Names and Numbers.
 * 
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, you can obtain one at https://mozilla.org/MPL/2.0/.
 */

/*
 * Developed by Sinodun IT (www.sinodun.com)
 */

/* 
 * File:   DSCStrategyFactory.h
 */

#ifndef DSCSTRATEGYFACTORY_H
#define	DSCSTRATEGYFACTORY_H

#include <string>
#include "dsc_types.h"
#include "DSCStrategy.h"

using namespace std;

class DSCStrategyFactory {
    DSCStrategyFactory();
    ~DSCStrategyFactory();
public:
    static vector<DSCStrategy*> createStrategy(const string &server, const string &name, bool rssac);
    static vector<DSCStrategy*> createStrategyDat(const string &server, const string &name);
};

#endif	/* DSCSTRATEGYFACTORY_H */

