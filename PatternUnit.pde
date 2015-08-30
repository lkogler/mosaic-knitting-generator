 /**
 * Author: Laura Kogler
 * License: This code is licensed under the terms of the GPL v.3
 */
class PatternUnit
{
  int[][] stitches;
  int unitHeight;
  int unitWidth; 

  PatternUnit()
  {
    unitHeight = 8;
    unitWidth = 8;
    stitches = new int[unitHeight][unitWidth];

    FillPattern();
    int[][] st = {  
      {
        0, 1, 0, 1, 0, 1, 0, 1      }
      ,
      {
        0, 1, 0, 1, 1, 1, 0, 1      }
      ,
      {
        0, 1, 0, 0, 0, 1, 0, 0      }
      ,
      {
        0, 1, 1, 1, 0, 1, 1, 1      }
      ,
      {
        0, 1, 0, 1, 0, 0, 0, 1      }
      ,
      {
        0, 1, 0, 1, 1, 1, 0, 1      }
      ,
      {
        0, 1, 0, 0, 0, 1, 0, 1      }
      ,
      {
        0, 1, 1, 1, 0, 1, 0, 1      }  
    };

    stitches = st;
  }

  PatternUnit(int _unitHeight, int _unitWidth)
  {
    unitHeight = _unitHeight;
    unitWidth = _unitWidth;
    stitches = new int[unitHeight][unitWidth];

    FillPattern();
  }

  void FillPattern()
  {
    // Even numbered rows are color A (0)
    // Odd numbered rows are color B (1)
    for(int row=0; row<unitHeight; row++)
    { 
      for(int col=0; col<unitWidth; col++)
      {
        stitches[row][col] = int(random(1.0)+0.5);
        if(col>0) // check previous stitch. 
        {
          if(stitches[row][col-1] != row%2)
            stitches[row][col] = row%2;
          else
            stitches[row][col] = int(random(1)+0.5);
        } 
        if(col==unitWidth-1)
        {
          if(stitches[row][col] != row%2 && stitches[row][0] != row%2)
            stitches[row][0] = row%2;
        }
        if(row>0) // check previous row
        {
          if(stitches[row][col] != row%2 && stitches[row-1][col] == row%2)
            stitches[row][col] = row%2; 
        }
      }
    }
    // Check last row against first row
    for(int col=0; col<unitWidth; col++)
    {
      if(stitches[0][col] != 0 && stitches[unitHeight-1][col] == 0)
        stitches[0][col] = 0; 
    }

  }

  void Draw(int _stitchSize, int _startX, int _startY, color _colorA, color _colorB, boolean flipX, boolean flipY)
  {
    noStroke();
    for(int row=0; row<unitHeight; row++)
    {
      for(int col=0; col<unitWidth; col++)
      {
        if(stitches[row][col]==0) 
        {
          fill(_colorA);
        }
        else
        {
          fill(_colorB);
        }

        rect(_startX+col*_stitchSize, _startY+row*_stitchSize, _stitchSize, _stitchSize);
        if(flipY)
          rect(_startX+col*_stitchSize, _startY+(2*unitHeight-2-row)*_stitchSize, _stitchSize, _stitchSize);

      }
      if(flipX)
      {
        int counter = unitWidth;
        for(int col=unitWidth-2; col>=0; col--)
        {
          if(stitches[row][col]==0) 
          {
            fill(_colorA);
          }
          else
          {
            fill(_colorB);
          }
          rect(_startX+counter*_stitchSize, _startY+row*_stitchSize, _stitchSize, _stitchSize);
          if(flipY)
            rect(_startX+counter*_stitchSize, _startY+(2*unitHeight-2-row)*_stitchSize, _stitchSize, _stitchSize);

          counter++;
        }
      }
    }

  }

  void Mutate()
  {
    boolean tryAgain=true;

    while(tryAgain)
    {
      tryAgain=false;

      int row = int(random(unitHeight));
      int col = int(random(unitWidth)); 

      //invert stitch at this row,col
      int newColor = (stitches[row][col]+1)%2;

      //if new stitch is not dominant color, check neighbors
      if(newColor != row%2)
      { 
        int prevStitch;
        if(col>0)   
          prevStitch =  stitches[row][(col-1)];
        else
          prevStitch = stitches[row][unitWidth-1];
        int nextStitch = stitches[row][(col+1)%unitWidth];

        if(newColor==prevStitch || newColor==nextStitch)         
          tryAgain=true;

        int stitchPrevRow;
        if(row>0)
          stitchPrevRow = stitches[row-1][col];
        else
          stitchPrevRow = stitches[unitHeight-1][col];

        int stitchNextRow = stitches[(row+1)%unitHeight][col]; 

        if(newColor != stitchPrevRow) 
          tryAgain=true;

        if(newColor != stitchNextRow)
          tryAgain=true;

        if(tryAgain==false)
          stitches[row][col]=newColor;   
      }
      else
      {
        stitches[row][col]=newColor; 
      }
    }
  }
  void Dissolve()
  {
    boolean tryAgain=true;

    while(tryAgain)
    {
      int row = int(random(unitHeight));
      int col = int(random(unitWidth)); 

      //Change stitch at this row,col to dominant color
      int newColor = row%2;

      if(stitches[row][col] != newColor)
      {
        stitches[row][col] = newColor;
        tryAgain=false;
      }
    }
  }


}



