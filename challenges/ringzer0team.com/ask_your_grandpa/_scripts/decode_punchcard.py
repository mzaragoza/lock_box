#!/bin/python3
import cv2

class PunchCard(object):

    def __init__(self, x_offset=131, y_offset=141, y_scale=52, x_scale=153):
        self.x_offset = x_offset
        self.y_offset = y_offset
        self.x_scale = x_scale
        self.y_scale = y_scale
        self.card_data = []
        self.charmap = {
            8: [":","#","@","'","=","\""],
            10: ["0","/","s","t","u","v","w","x","y","z"],
            11: ["-","j","k","l","m","n","o","p","q","r"],
            12: ['&',"a","b","c","d","e","f","g","h","i"],
            18: ["]",",","%","_",">","?"],
            19: ["!","$","*",")",";","\\"],
            20: ["[",".","<","(","+","^"]
        }

    def _decode_char(self, holes):
        if len(holes) == 0: return " "
        if len(holes) == 1:
            if holes[0] <= 9: return str(holes[0])
            return self.charmap[holes[0]][0]
        if len(holes) == 2:
            if holes[0] > 9: return self.charmap[holes[0]][holes[1]]
            if holes[1] == 8: return self.charmap[8][holes[0] - 2]
        if len(holes) == 3:
            return self.charmap[holes[0] + holes[2]][holes[1] - 2]

    def _get_pixels(self, filename):
        image = cv2.imread(filename)
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        return cv2.threshold(gray, 80, 255, cv2.THRESH_BINARY_INV)[1]

    def decode(self, filename):
        pixels = self._get_pixels(filename)
        y = self.y_offset
        for column in range(80):
            column_data = []
            x = self.x_offset
            for row in [12,11,10,1,2,3,4,5,6,7,8,9]:
                if pixels[x:x + 5, y:y + 10][4][9] > 0: column_data.append(row)
                x = x + self.x_scale
            y = y + self.y_scale
            self.card_data.append(self._decode_char(column_data))
        return "".join(self.card_data)
