# WebUI-Layouts

This repository contains a collection of LogRhythm WebUI Dashboard & Analyse layouts that focus on a clean dataset view to highlight areas of interest.  Not all metadata fields will be popualted by all log sources, and so these layouts focus on high value metadata fields that are common to all log sources.  The use of standard Widgets (Bar Charts with the focus on the value field) and colour schema provide an intuative view upon large sets of metadata.  In addition, time based layouts and top/bottom views provide a quick way to detect outliers.

All have been Created using LogRythm 7.2.x and default to 4 column width layout.  It's suggested to use the WebUI keyboard shortcuts for (L)ogs, (C)ase and (I)nspector to retain maximum screen estate while using the LogRhythm WebUI.

## Colour Use for Widgets
Grey = Taxonomy
Blue = Entity & Log Source
Yellow = Hosts
Green = Users

## Dashboards

###_1. Default (Time Range)
Provides time based comparison between metadata fields showing the last 1 hour vs the last 1 day:
* Top Classification 
* Top Common Event
* Top Log Source Trend
* Top Host (Origin)
* Top Host (Impacted)
* Top User (Origin)
* Top User (Impacted)

###_1. Default (Top & Bottom)
Provides Top 10 metadata fields view.
* Top Classification
* Top Common Event
* Top Vendor Message ID
* Top Log Source
* Top Host (Origin)
* Top Host (Impacted)
* Top User (Origin)
* Top User (Impacted)
* Top Classification Trend

###_1. AIE Event
Provides Top 10 metadata fields view across AIE Events only.
* Top Common Event Trend
* Top Classification
* Top Common Event
* Top Log Source Entity
* Bottom Classification
* Bottom Common Event
* Bottom Log Source Entity


