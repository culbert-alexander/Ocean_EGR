
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;

public class GenerateBTYENV {


	/**
	 * This class shows how to create a File in Java
	 * @param args
	 * @throws IOException 
	 */
	static String FS = System.getProperty("file.separator");
	public static final String FILE_PATH = FS+"Users"+FS+"maddienelson"+FS+"Documents"+FS+"Bathymetry";
	public static final int NUM_TEST_FILES = 5;
	public static final String BTY = ".bty";
	public static final String TEST_FILE = "testfile";
	public static final String NL = "\n";
	public static final String SPACE = "  ";
	public static final String BIG_SPACE = "                     ";
	public static final String LAKE_DATA = "FallsLake";


	public static int NUM_ROWS;
	public static int NUM_COLS;
	
	static double[][] grid;
	
	public static ArrayList<String> FILE_NAMES = new ArrayList<String>(){{
	    add("Washington");
	    add("Adams");
	    add("Jefferson");
	    add("Madison");
	    add("Monroe");
	    add("Quincy");
	}};
	//FOR ENV
	public static final double FREQ = 1500.0;
	private static final int NMEDIA = 1;
	private static final String SSPOPT = "'CVW'";
	private static final double DEPTH1 = (double)51;
	private static final double DEPTH2 = 0.0;
	private static final double DEPTH3 = 20.0;
	private static final double VAL1 = 0;
	private static final double VAL2 = 10;
	private static final double VAL3 = 20;
	private static final String NUM1 = null;
	private static final String NSX = null;
	private static final String XCORD_SOURCE = null;
	private static final String NSY = null;
	private static final String YCORD_SOURCE = null;
	private static final String NSD = null;
	private static final String SD = null;
	private static final String NRD = null;
	private static final String RD0 = null;
	private static final String RD1 = null;
	private static final String NR = null;
	private static final String R0 = null;
	private static final String R1 = null;
	private static final String NUM2 = null;
	private static final String NUM3 = null;
	private static final String NUM4 = null;
	private static final String NUM5 = null;
	private static final String NTHETA = null;
	private static final int BANG1 = 0;
	private static final String BANG0 = null;
	private static final String RCIS = null;
	private static final String NALPHA1 = null;
	private static final String NALPHA2 = null;
	private static final String ALPHA1 = null;
	private static final String ALPHA2 = null;
	private static final int NBETA2 = 0;
	private static final String NBETA1 = null;
	private static final String BETA1 = null;
	private static final String BETA2 = null;
	private static final double STEP2 = 1;
	private static final double STEP1 = 0.0;
	private static final double STEP3 = 1;
	private static final double STEP4 = 50.0;
	
	
	//max depth = 13 ft
	//min depth = 0 ft
	private static final double MAX_DEPTH = 13.0;
	private static final double MIN_DEPTH = 5.0;


	public static void main(String[] args) throws IOException {

		//absolute file name with path
		for(int fileNum = 0; fileNum<NUM_TEST_FILES; fileNum++) {
			initMakeFiles(fileNum);
		}

	}
	
	
	private static void initMakeFiles(int fileNum) throws IOException {
		String btyFileName = FILE_PATH+FS+LAKE_DATA+fileNum+BTY;
		File btyFile = new File(btyFileName);
		checkFile(btyFile, btyFileName);
		//String envFileName = FILE_PATH+FS+FILE_NAMES.get(fileNum)+fileNum+BTY;
		//File envFile = new File(envFileName);
		//checkFile(envFile, envFileName);
		makeBTYFile(fileNum,btyFile);
		//makeENVFile(fileNum,envFile);		
	}


	private static void makeENVFile(int fileNum, File envFile) throws IOException {
		makeGrid(fileNum+1);
		String str = createENVString(fileNum);
		writeToFile(envFile, str);		
	}


	private static String createENVString(int fileNum) {
		StringBuilder str = new StringBuilder();
		String xLabels = generateLabel(NUM_COLS);
		String yLabels = generateLabel(NUM_ROWS);
		
		str.append("'"+FILE_NAMES.get(fileNum)+" (3D run)' ! TITLE"+NL); //don't know what the R is for...could be L or C
		str.append(FREQ+BIG_SPACE+"! FREQ (Hz)"+NL);
		str.append(NMEDIA+BIG_SPACE+"! NMEDIA"+NL);
		str.append(SSPOPT+BIG_SPACE+"! SSPOPT (Analytic or C-Linear interpolation)"+NL);
		str.append(DEPTH1+SPACE+DEPTH2+SPACE+DEPTH3+SPACE+"! DEPTH of bottom (m)"+NL);
		str.append(BIG_SPACE+VAL1+SPACE+"/"+NL);
		str.append(BIG_SPACE+VAL2+SPACE+"/"+NL);
		str.append(BIG_SPACE+VAL3+SPACE+"/"+NL);
		str.append("'A~' 0.0"+ NL); //WHAT IS THIS?
		str.append(NUM1+SPACE+NUM2+SPACE+NUM3+SPACE+NUM4+SPACE+NUM5+SPACE+"/"+NL);
		str.append(NSX+BIG_SPACE+"! Nsx number of source coordinates in x"+NL);
		str.append(XCORD_SOURCE+SPACE+"/"+BIG_SPACE+"! x coordinate of source (km)"+NL);
		str.append(NSY+BIG_SPACE+"! Nsy number of source coordinates in y"+NL);
		str.append(YCORD_SOURCE+SPACE+"/"+BIG_SPACE+"! y coordinate of source (km)"+NL);
		str.append(NSD+BIG_SPACE+"! NSD"+NL);
		str.append(SD+SPACE+"/"+BIG_SPACE+"! SD(1:NSD) (m)"+NL);
		str.append(NRD+BIG_SPACE+"! NRD"+NL);
		str.append(RD0+SPACE+RD1+SPACE+"/"+BIG_SPACE+"! RD(1:NRD) (m)"+NL);
		str.append(NR+BIG_SPACE+"! NR"+NL);
		str.append(R0+SPACE+R1+SPACE+"/"+BIG_SPACE+"! R(1:NR) (km)"+NL);
		str.append(NTHETA+BIG_SPACE+"! Ntheta (number of bearings)"+NL);
		str.append(BANG0+SPACE+BANG1+SPACE+"/"+BIG_SPACE+"! bearing angles (degrees)"+NL);
		str.append(RCIS+BIG_SPACE+"! 'R/C/I/S'"+NL);
		str.append(NALPHA1+SPACE+NALPHA2+BIG_SPACE+"! NALPHA"+NL);
		str.append(ALPHA1+SPACE+ALPHA2+SPACE+"/"+BIG_SPACE+"! alpha1, 2 (degrees) Elevation/declination angle fan"+NL);
		str.append(NBETA1+SPACE+NBETA2+BIG_SPACE+"! Nbeta"+NL);
		str.append(BETA1+SPACE+BETA2+SPACE+"/"+BIG_SPACE+"! beta1, beta2 (degrees) bearine angle fan"+NL);
		str.append(STEP1+SPACE+STEP2+SPACE+STEP3+SPACE+STEP4+BIG_SPACE+"! STEP (m), Box%x (km) Box%y (km) Box%z (m)"+NL);
		return str.toString();
	}


	private static void checkFile(File file, String name) throws IOException {
		if(file.createNewFile()){
			System.out.println(name+" File Created");
		}
		else {
			System.out.println("File "+name+" already exists");
		}		
	}


	private static void makeBTYFile(int fileNum, File btyFile) throws IOException {
		makeGrid(fileNum+1);
		String str = createBTYString(fileNum);
		writeToFile(btyFile, str);
	}
	


	private static void writeToFile(File file, String str) throws IOException {
		BufferedWriter writer = new BufferedWriter(new FileWriter(file));
		writer.write(str);
		writer.close();			
	}


	//we want shapes that would make sense
	//maybe get quandrants in the files and then have the quandrants have peaks or valleys.
	private static String createBTYString(int fileNum) {
		StringBuilder str = new StringBuilder();
		String xLabels = generateLabel(NUM_COLS);
		String yLabels = generateLabel(NUM_ROWS);
		str.append("'R'"+NL); //don't know what the R is for...could be L or C
		str.append(NUM_COLS+NL); //num rows.
		str.append(xLabels+NL);  //x axis labels --> make an array list
		str.append(NUM_ROWS+NL);
		str.append(yLabels+NL);
		str.append(gridAsString()+NL);
		return str.toString();
	}


	private static String gridAsString() {
		StringBuilder gridStr = new StringBuilder();
		for (int i = 0; i<NUM_ROWS; i++) {
			for (int j = 0; j<NUM_COLS; j++) {
				gridStr.append(grid[i][j]+SPACE);
			}
			gridStr.append(NL);
		}
		return gridStr.toString();
	}


	private static void makeGrid(int num) {
		NUM_ROWS = 8;
		NUM_COLS = 16;
		grid = new double[NUM_ROWS][NUM_COLS];
		int halfR = NUM_ROWS/2;
		int halfC = NUM_COLS/2;
		double a = 1.55;
		double b = 1.32;
		double e = 1.28;
		double d = 4.7;
		makeSlopeQuad(0, 0, NUM_ROWS, NUM_COLS, num);
		//makeQuad(halfR, 0, NUM_ROWS, halfC);
		//makeQuad(0, halfC, halfR, NUM_COLS);
		//makeQuad(halfR, halfC, NUM_ROWS, NUM_COLS);
	}
	
	private static void makeSlopeQuad(int iStart, int jStart, int rowMax, int colMax,int num) {
		int midR = (int)((rowMax-iStart)/2);
		int midC = (int)((colMax-iStart)/2);
		for(int i = iStart; i<rowMax; i++) {
			for(int j = jStart; j<colMax; j++) {

				if(i<midR && j<midC) {
					grid[i][j]=(Math.floor((Math.abs(rowMax+colMax - i - j))*1000)/1000);
				}//bottomright
				else if(i<midR && j>=midC) {
					grid[i][j]=(Math.floor((Math.abs(j+colMax - i))*1000)/1000);
				}
				else if(i>=midR && j<midC) {
					grid[i][j]=(Math.floor((Math.abs(rowMax+ i - j))*1000)/1000);
				}
				else if(i>=midR && j>=midC) {
					grid[i][j]=(Math.floor((Math.abs( i + j))*1000)/1000);
				}
				else {
					grid[i][j] = i+j;
				}
			}
		}		
	}
	private static void makeQuad(int iStart, int jStart, int rowMax, int colMax) {
		int midR = (int)((rowMax-iStart)/2);
		int midC = (int)((rowMax-iStart)/2);
		for(int i = iStart; i<rowMax; i++) {
			for(int j = jStart; j<colMax; j++) {

				if(i<midR && j<midC) {
					grid[i][j]=Math.floor((Math.abs(rowMax+colMax - i - j))*1000)/1000;
				}//bottomright
				else if(i<midR && j>=midC) {
					grid[i][j]=Math.floor((Math.abs(j+colMax - i))*1000)/1000;
				}
				else if(i>=midR && j<midC) {
					grid[i][j]=Math.floor((Math.abs(rowMax+ i - j))*1000)/1000;
				}
				else if(i>=midR && j>=midC) {
					grid[i][j]=Math.floor((Math.abs( i + j))*1000)/1000;
				}
				else {
					grid[i][j] = 0.05;
				}
			}
		}		
	}


	private static void makeQuad(int iStart, int jStart, int rowMax, int colMax, double a) {
		int midR = (int)((rowMax-iStart)/2);
		int midC = (int)((rowMax-iStart)/2);
		for(int i = iStart; i<rowMax; i++) {
			for(int j = jStart; j<colMax; j++) {
				//bottomleft	  Math.floor(value * 100) / 100;

				if(i<midR && j<midC) {
					grid[i][j]=Math.floor((a+(i*j)+j+i)*1000)/1000;
				}//bottomright
				else if(i<midR && j>=midC) {
					grid[i][j]=Math.floor((Math.abs(a-(i*j)))*1000)/1000;
				}
				else if(i>=midR && j<midC) {
					grid[i][j]=Math.floor((Math.abs(a+j-i))*1000)/1000;
				}
				else if(i>=midR && j>=midC) {
					grid[i][j]=Math.floor((Math.abs(a*i+j))*1000)/1000;
				}
				else {
					grid[i][j] = 0.05;
				}
			}
		}		
	}

	private static void makeLakeQuad(int iStart, int jStart, int rowMax, int colMax, double a) {
		int midR = (int)((rowMax-iStart)/2);
		int midC = (int)((rowMax-iStart)/2);
		for(int i = iStart; i<rowMax; i++) {
			for(int j = jStart; j<colMax; j++) {
				//bottomleft	  Math.floor(value * 100) / 100;
				double val = getMaxLake(rowMax+colMax);
				if(i<midR) {
					//grid[i][j] = getMaxLake(Math.floor(obj*1000)/1000);
				}
//				if(i<midR && j<midC) {
//					grid[i][j]=getMaxLake(Math.floor((val - i*0.1 - j*0.1)*1000)/1000);
//				}//bottomright
//				else if(i<midR && j>=midC) {
//					grid[i][j]=getMaxLake(Math.floor((val - i*0.1 + j*0.1)*1000)/1000);
//				}
//				else if(i>=midR && j<midC) {
//					grid[i][j]=getMaxLake(Math.floor((val + i*0.1 - j*0.1)*1000)/1000);
//				}
//				else if(i>=midR && j>=midC) {
//					grid[i][j]=getMaxLake(Math.floor((val + i*0.1 + j*0.1)*1000)/1000);
//				}
//				else {
//					grid[i][j] = Math.floor(getMaxLake((i+j) *(i*j))*1000)/1000;
//				}
			}
		}		
	}

	private static double getMaxLake(double d) {
		if(d<MAX_DEPTH && MIN_DEPTH<d) return d;
		if(d>MAX_DEPTH && MIN_DEPTH<d) return getMaxLake(d/2);
		if(d<MAX_DEPTH && MIN_DEPTH>d) return getMaxLake(d+2);
		return d;
	}

	private static String generateLabel(int numVals) {
		StringBuilder label = new StringBuilder();
		double val = 0.0;
		for(int i = 0; i<numVals; i++) {
			val = (getMaxLabel(Math.floor(val+i)*1000)/1000)+5;
			label.append(val+SPACE);
		}
		return label.toString();
	}
	
	private static double getMaxLabel(double d) {
		//if(d>100) return getMaxLabel(d/2);
		return d;
	}


}


//the env is just telling matlab to write text to a file

//the env file with the bathymetry file lets us write an arrival file and then the arrival file will create the sound file
//the sound file 

//how are bathymetry files and env files related
//the environment file defines the depth range, it also must have the same name. that is a given
//provides other data, speed of the sound etc.

//writen_env is in the acoustic toolbox under matlab readWrite file


//bottom coefs might be different



