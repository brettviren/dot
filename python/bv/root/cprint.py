#!/usr/bin/env python
'''
Enhance TCanvas::Print()
'''

import os
import ROOT

class Printer(object):
    '''
    Encapsulate a canvas and print based on a file name pattern.

    printer = cprint.Printer(canvas, '/path/to/my/plots/plot%(cound)3d.%(ext)s')

    '''

    def __init__(self, canvas, pattern, 
                 multi_files = ['pdf','png','svg'], 
                 single_file = ['pdf']):
        '''
        Create a printer for the given canvas.

        Output files are produced based on interpolating the given
        file pattern.  This pattern can contain a "%d" which will be
        interpolated with an incrementing number.  It will be
        interpolated with 0 for single file output.

        The "multi_files" list specifies extensions for producing
        multiple files, one file per print.

        The "single_file" list specifies extensions for producing a
        multiple-page, single file for all prints.  If an incompatible
        extension is specified it will be ignored.

        '''

        self.canvas = canvas
        self.oneshots = [pattern + '.' + ext for ext in multi_files]
        self.count = 0
        self.compendiums = []
        for ext in single_file:
            if ext not in ['pdf','ps']: continue
            filename = pattern % 0
            filename += '.' + ext
            self.compendiums.append(filename)
            self.canvas.Print(filename + '[')
            continue

        return

    def __call__(self):
        'Call me each time the canvas is ready for printing'
        self.count += 1
        for filename in [p%self.count for p in self.oneshots] + self.compendiums:
            self.canvas.Print(filename)
        return

    def __del__(self):
        self.close()
        return

    def close(self):
        'Close any multi-page single-file output'
        if not self.canvas: return
        for filename in self.compendiums:
            self.canvas.Print(filename + ']')
        self.canvas = None
        return

    pass

def test():
    c = ROOT.TCanvas("c","canvas")
    p = Printer(c,'cprint-test-%03d')
    h = ROOT.TH1F("h","Test Gaussian",100,-10,10)
    for n in range(10):
        h.FillRandom("gaus")
        h.Draw()
        p()
        continue
    p.close()

        
if '__main__' == __name__:
    test()
