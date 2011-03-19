Eye Street Research iOS Utils
=============================
Peter DeWeese, Eye Street Research, LLC. http://research.eyestreet.com
Purpose and Method
------------------------
The primary purpose of this library is to DRY out verbose iOS code and reduce unnecessicary ceremony using language features such as categories, @dynamic, blocks, and the occasional macro.  Rails and Java standards are borrowed from when reasonable.  When methods are borrowed from other languages, they should generally be conformed to Objective-C convention.  Derivative values should be made available as read only properties whenever possible for code brevity, as in the example `@" asdf   ".strip`.

Installation
------------
I prefer including the source of small libraries in Cocoa Touch projects as git submodules to give full insight, easier contribution, and less compilation changes.  Drag the es_ios_utils/es_ios_utils directory to your project and do not select to copy.  When testing, open the es_ios_utils project.  Importing the entire project and adding its targets as dependencies may be an alternative.

`#import "ESUtils.h"` imports all of the utility categories and macros.  Include it in your .pch file.

###Framework
The default build creates a framework that can be included in another project.

###Statically Linked Library
There is no target for this right now, but it can be done.  When including the compiled library in your project, open the build properties and add `-ObjC` to "Other Linker Flags".  In Xcode 3.x, use `-all_load` or `-force_load`.  Without this flag, categories may not link properly.

Features
-----------
See ESNSCategories.h and ESUICategories.h.

###isEmpty and isNotEmpty properties
Implemented for NSArray, NSNull – which is always empty, NSSet, and NSString.  nil.isEmpty returns false, so a full check requires `!s || s.isEmpty`. Preferably, `nil.isNotEmpty` returns false so no existance check is necessicary.

###ESDynamicMethodResolver
Use @dynamic to conveniently bind properties files, xml documents, etc.

###macros
Very common and generic operations are included as macros for brevity, prefixed with '$'.  Examples:
`$array(object1, object2, nil)`
`$set(object1, object2, nil)`
`$format(@"My Format: %i", 3)`

To Do
---------
* Add application tests for UI categories and ESBoundUserDefaults.
* Add application tests for core data.
* Test framework product.