/* 
 * Copyright 2014 Internet Corporation for Assigned Names and Numbers.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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

