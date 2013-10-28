#include<stdio.h>

float latencyMatrix[8][8]={{0, 251.340, 342.655, 271.222, 137.234, 258.073,238.073, 248.907},
	{247.053, 0, 358.541, 45.054, 254.231, 30.072, 15.102, 51.956},
	{349.292, 354.536,0,389.775,315.635,365.087, 373.777,350.916},
	{288.656,34.488,389.895,0,276.726,74.492,58.191,31.391},
	{135.338,254.839,316.737,262.823,0,224.844,233.830,229.458},
	{253.396,34.415,319.499,48.461,224.273,0,24.433,30.364},
	{237.956,20.201,377.553,58.001,75.132,25.143,0,38.817},
	{247.505,56.980,352.327,36.771,230.819,30.889,39.176,0}
};
float minLatencyMatrix[8][8]={{0, 251.340, 342.655, 271.222, 137.234, 258.073,238.073, 248.907},
	{247.053, 0, 358.541, 45.054, 254.231, 30.072, 15.102, 51.956},
	{349.292, 354.536,0,389.775,315.635,365.087, 373.777,350.916},
	{288.656,34.488,389.895,0,276.726,74.492,58.191,31.391},
	{135.338,254.839,316.737,262.823,0,224.844,233.830,229.458},
	{253.396,34.415,319.499,48.461,224.273,0,24.433,30.364},
	{237.956,20.201,377.553,58.001,75.132,25.143,0,38.817},
	{247.505,56.980,352.327,36.771,230.819,30.889,39.176,0}
};

void processMatrix(){
	int i,j,k;
	float min;

	for(i=0; i<8; i++){
		for(j=0; j<8; j++){
			minLatencyMatrix[i][j] = latencyMatrix[i][j];
			for (k=0; k<8; k++){
				min = latencyMatrix[i][k]+latencyMatrix[k][j];
				if((min < latencyMatrix[i][j])&&(min < minLatencyMatrix[i][j])){
					
					minLatencyMatrix[i][j] = min;
				}
			}
		}
	}
	
	for(i=0;i<8;i++)
	{
		for(j=0;j<8;j++){
			if(!minLatencyMatrix[i][j]== 0){
				minLatencyMatrix[i][j] = latencyMatrix[i][j]/minLatencyMatrix[i][j];
			}
			printf("%f\n", minLatencyMatrix[i][j]);
		}
	}
	
}

int main()
{
	processMatrix();
	return 0;
}