
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;

public class GenerateBathymetry {


	/**
	 * This class shows how to create a Bathymetry File in Java
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
		makeBTYFile(fileNum,btyFile);
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

//	private static void makeLakeQuad(int iStart, int jStart, int rowMax, int colMax, double a) {
//		int midR = (int)((rowMax-iStart)/2);
//		int midC = (int)((rowMax-iStart)/2);
//		for(int i = iStart; i<rowMax; i++) {
//			for(int j = jStart; j<colMax; j++) {
//				//bottomleft	  Math.floor(value * 100) / 100;
//				double val = getMaxLake(rowMax+colMax);
//				if(i<midR) {
//					//grid[i][j] = getMaxLake(Math.floor(obj*1000)/1000);
//				}
////				if(i<midR && j<midC) {
////					grid[i][j]=getMaxLake(Math.floor((val - i*0.1 - j*0.1)*1000)/1000);
////				}//bottomright
////				else if(i<midR && j>=midC) {
////					grid[i][j]=getMaxLake(Math.floor((val - i*0.1 + j*0.1)*1000)/1000);
////				}
////				else if(i>=midR && j<midC) {
////					grid[i][j]=getMaxLake(Math.floor((val + i*0.1 - j*0.1)*1000)/1000);
////				}
////				else if(i>=midR && j>=midC) {
////					grid[i][j]=getMaxLake(Math.floor((val + i*0.1 + j*0.1)*1000)/1000);
////				}
////				else {
////					grid[i][j] = Math.floor(getMaxLake((i+j) *(i*j))*1000)/1000;
////				}
//			}
//		}		
//	}

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