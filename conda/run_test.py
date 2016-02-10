import sys
import os
import dlib
import numpy as np
from PIL import Image

if __name__ == "__main__":
    try:
        recipe_filepath = os.environ.get('RECIPE_DIR', os.path.dirname(os.path.abspath(__file__)))
        lena_path = os.path.join(recipe_filepath, 'lena.png')
        
        lena = np.array(Image.open(lena_path))
        detector = dlib.get_frontal_face_detector()
        results = detector(lena)
        
        print('Found {} faces'.format(len(results)))
        assert(len(results) == 1)
    except Exception as e:
        print(e)
        sys.exit(1)

