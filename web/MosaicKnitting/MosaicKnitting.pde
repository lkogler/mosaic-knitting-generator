/**
* MosaicKnitting
* 
* Generates random mosaic knitting patterns
*
*/

import processing.pdf.*; //required to make pdf happen

void setup() {
	
	// Configurable parameters
//	int unitWidth = 10;        // How many stitches wide is the pattern unit
//	int unitHeight = 10;       // How many stitches tall is the pattern unit (must be an even number)
//	int repsX = 6;            // How many times to repeat the pattern in the horizontal direction
//	int repsY = 6;           // How many times to repeat the pattern in the vertical direction
//	int stitchSize = 6;       // How many pixels to draw per stitch
//	boolean flipX=true;       // The pattern unit is flipped for horizontal symmetry 
//	boolean flipY=true;       // The pattern unit is flipped for vertical symmetry
//	boolean mutate = false;   // If true, one stitch will be changed on each repetition of the pattern
//	boolean dissolve = false; // If true, the pattern will be disolved on each repetition
	boolean savePDF = false;  // If true, an output file will be created each time the program is run
	boolean randomizeColor = false; // If true, pick a random color
//	int seed = 150;
	
	randomSeed(seed);
	
	
	colorMode(HSB, 360, 100, 100);
	color colorA;
	if(randomizeColor)
	{
		colorA = color(random(360),100,100);
	}
	else
	{
		colorA = color(hueA,satA,briA);
	}
	//color colorB = color(255, 0, 100);
	color colorB = color(hueB,satB,briB);
	
	
	PatternUnit unit = new PatternUnit(unitHeight,unitWidth);
	//PatternUnit unit = new PatternUnit();
	
	int stepX;
	int stepY;
	if(flipX) stepX = (unitWidth*2-2);
	else stepX = unitWidth;
	
	if(flipY) stepY = (unitHeight*2-2);
	else stepY = unitHeight;
	
	size((stepX*repsX*stitchSize)+stitchSize*int(flipX), (stepY*repsY*stitchSize)+stitchSize*int(flipY));
	
	background(0);
	if(savePDF)   beginRecord(PDF, "Pattern_S"+seed+"_X"+unitWidth+"_Y"+unitHeight+".pdf");  
	
	for(int y = 0; y<repsY; y++)
	{
		if(mutate)
		{
			unit.Mutate();
		}
		if(y>0 && dissolve) unit.Dissolve();
		for(int x=0; x<repsX; x++)
		{
			unit.Draw(stitchSize, x*stepX*stitchSize, y*stepY*stitchSize, colorA, colorB, flipX, flipY);
		}
	}
	
	if(savePDF) endRecord(); //write to pdf
}

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
			{ 0, 1, 0, 1, 0, 1, 0, 1 },
			{ 0, 1, 0, 1, 1, 1, 0, 1 },
			{ 0, 1, 0, 0, 0, 1, 0, 0 },
			{ 0, 1, 1, 1, 0, 1, 1, 1 },
			{ 0, 1, 0, 1, 0, 0, 0, 1 },
			{ 0, 1, 0, 1, 1, 1, 0, 1 },
			{ 0, 1, 0, 0, 0, 1, 0, 1 },
			{ 0, 1, 1, 1, 0, 1, 0, 1 }  };
		
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



