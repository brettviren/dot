#!/usr/bin/env python
'''
Make a rainbow palette for ROOT


'''

import ROOT
from array import array

first_color_number = None
ncolors = None
def palette(alpha = None):
    '''
    Set palette to a nicer rainbow than the default.  

    Set alpha of transparency to a float in [0,1] to set the colors to
    have alpha-blending (may only work in PDFs).
    '''
    NRGBs = 5;
    NCont = 255;

    stops = array('d',[ 0.00, 0.34, 0.61, 0.84, 1.00 ])
    red   = array('d',[ 0.00, 0.00, 0.87, 1.00, 0.51 ])
    green = array('d',[ 0.00, 0.81, 1.00, 0.20, 0.00 ])
    blue  = array('d',[ 0.51, 1.00, 0.12, 0.00, 0.00 ])
    global first_color_number
    global ncolors
    first_color_number = ROOT.TColor.CreateGradientColorTable(NRGBs, stops, red, green, blue, NCont)
    ncolors = NCont
    ROOT.gStyle.SetNumberContours(NCont)

    if alpha:
        for icol in range(ncolors):
            icol += first_color_number
            tcol = ROOT.gROOT.GetColor(icol)
            try:
                tcol.SetAlpha(alpha)
            except AttributeError,msg:
                print msg, 'skipping'
                return
            continue
        pass
    return


if __name__ == '__main__':
    palette(0.01)
    print 'rainbow of %d colors start at %d' % (ncolors, first_color_number)

