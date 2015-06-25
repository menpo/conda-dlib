import sys
import dlib
import numpy as np
from scipy import misc

if __name__ == "__main__":
    try:
        lena = misc.lena().astype(np.uint8)
        detector = dlib.get_frontal_face_detector()
        results = detector(lena)
        print('Found {} faces'.format(len(results)))
        assert(len(results) == 1)
    except:
        sys.exit(1)
