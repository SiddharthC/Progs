#include <iostream>
#include <math.h>
#include <stdlib.h>

using namespace std;

typedef struct Vector3{
	double X;
	double Y;
	double Z;
}Vector3;

typedef struct Ray{
	Vector3 p; //starting point of ray
	Vector3 d; //direction of ray
	void RayPopulator(double x, double y, double z, double vx, double vy, double vz){
		p.X = x;
		p.Y = y;
		p.Z = z;
		d.X = vx;
		d.Y = vy;
		d.Z = vz;
	}
}Ray;

double distancer(Vector3 a, Vector3 b)
{
	double dist = sqrt(pow((b.X-a.X),2)+ pow((b.Y-a.Y),2) +pow((b.Z-a.Z),2));
	return dist;
}

void VectorPrinter(Vector3 v1){
	cout<<"\nThe point is ( "<<v1.X<<" , "<<v1.Y<<" , "<<v1.Z<<" )\n";
}

Vector3 Vadder(Vector3 a, Vector3 b, double step){
	Vector3 result;
	result.X = a.X + step*b.X;
	result.Y = a.Y + step*b.Y;
	result.Z = a.Z + step*b.Z;
	return result;
}

Vector3 ApproximateRayIntersection(Ray r1, Ray r2){
	
	Vector3 result;
	double shortest_distance;

	bool isParallel = false;

	if((r1.d.Y*r2.d.Z == r2.d.Y*r1.d.Z)&&(r1.d.X*r2.d.Z == r2.d.X*r1.d.Z)&& (r1.d.X*r2.d.Y == r2.d.X*r1.d.Y))
	{
		isParallel = true;

		shortest_distance = sqrt(pow(((r2.p.Y - r1.p.Y)*r1.d.Z  - (r2.p.Z - r1.p.Z)*r1.d.Y),2) +pow(((r2.p.X - r1.p.X)*r1.d.Z - (r2.p.Z - r1.p.Z)*r1.d.X ),2) 
				+ pow(((r2.p.X - r1.p.X)*r1.d.Y - (r2.p.Y - r1.p.Y)*r1.d.X),2))/(sqrt(pow(r1.d.X,2) + pow(r1.d.Y,2) + pow(r1.d.Z,2)));
		//sqrt( ((b2-b1)z1 - (c2-c1)y1)^2 + ((a2-a1)z1 - (c2-c1)x1)^2 + ((a2-a1)y1 - (b2-b1)x1)^2 ) / sqrt( x1^2 + y1^2 + z1^2 )
		cout<<"Error: The two rays are parallel.\nShortest distance between the lines is: "<<shortest_distance<<"\n";
		exit(0);
	}
	
	//calculate shortest distance
	shortest_distance = fabs(((r1.p.X - r2.p.X)*(r1.d.Y*r2.d.Z - r2.d.Y*r1.d.Z) - (r1.p.Y - r2.p.Y)*(r1.d.X*r2.d.Z - r2.d.X*r1.d.Z) 
		+ (r1.p.Z - r2.p.Z)*(r1.d.X*r2.d.Y - r2.d.X*r1.d.Y))/(sqrt(pow((r1.d.Y*r2.d.Z - r2.d.Y*r1.d.Z),2) + pow((r1.d.X*r2.d.Z - r2.d.X*r1.d.Z),2) 
			+ pow((r1.d.X*r2.d.Y - r2.d.X*r1.d.Y),2))));
//	cout<<"Problematic shortest distance: "<<shortest_distance<<"\n";
		//(a1-a2)(y1z2-y2z1) - (b1-b2)(x1z2-x2z1)  + (c1-c2)(x1y2-x2y1)/sqrt((y1z2-y2z1)^2 + (x1z2-x2z1)^2 + (x1y2-x2y1)^2)

	if(shortest_distance == 0){
		//find point of intersection
		result.X = (r1.d.X*r2.d.X*(r1.p.Y - r2.p.Y) + r1.d.X*r2.d.Y*r2.p.X - r2.d.X*r1.d.Y*r1.p.X)/(r1.d.X*r2.d.Y - r2.d.X*r1.d.Y);
		result.Y = (r1.d.Y*r2.d.Y*(r2.p.X - r1.p.X) + r1.p.Y*r1.d.X*r2.d.Y - r2.p.Y*r2.d.X*r1.d.Y)/(r1.d.X*r2.d.Y - r2.d.X*r1.d.Y);
		result.Z = (r1.d.Z*r2.d.Z*(r2.p.X - r1.p.X) + r1.d.X*r2.d.Z*r1.p.Z - r2.d.X*r1.d.Z*r2.p.Z)/(r1.d.X*r2.d.Z - r2.d.X*r1.d.Z);

		if(((result.X-r1.p.X)/r1.d.X < 0) || ((result.X-r2.p.X)/r2.d.X < 0))//error if intersection is in reverse direction
		{
			cout<<"Error: The lines intersect in reverse directions\n";
		}

		/*	x1x2(b1-b2) + x1y2a2 - x2y1a1
			/(x1y2 - x2y1)
			y1y2(a2-a1) + b1x1y2 - b2x2y1
			/(x1y2 - x2y1)
			z1z2(a2-a1) + x1z2c1 - x2z1c2
			/(x1z2-x2z1)*/
	}
	else{
		//find the approximate point
		double step=1;
		Vector3 s1 = r1.p;
		Vector3 s2 = r2.p;
		double current_dist = 9999;
		double previous_dist = 9999;

		double tmpdist1 = distancer(s2, s1);
		double tmpdist2 = distancer(Vadder(s2, r2.d, step), Vadder(s1, r1.d, step));
		if(tmpdist2 > tmpdist1)
		{
			cout<<"Error: The lines diverge from start.\n";
			result.X = (r1.p.X + r2.p.X)/2;
			result.Y = (r1.p.Y + r2.p.Y)/2;
			result.Z = (r1.p.Z + r2.p.Z)/2;
		}
		else{
			while(1){
				current_dist = distancer(s1, s2);
//				cout<<"Current dist: "<<current_dist<<"\n";
				if(current_dist < previous_dist)
				{

					if((int)(current_dist*1000) == (int)(shortest_distance*1000))
					{
						break;
					}
//					cout<<"in if\n";
					previous_dist = current_dist;
					s1 = Vadder(s1, r1.d, step);
					s2 = Vadder(s2, r2.d, step);
				}
				else
				{
//					cout<<"in else\n";
					step = step/2;
					if((int)(step*1000) == 0)
					{
						break;
					}
					s1 = Vadder(s1, r1.d, (-1)*step);
					s2 = Vadder(s2, r2.d, (-1)*step);
				}
			}
//			VectorPrinter(s1);
//			VectorPrinter(s2);
			result.X = (s1.X + s2.X)/2;
			result.Y = (s1.Y + s2.Y)/2;
			result.Z = (s1.Z + s2.Z)/2;
		}
	}
	return result;
}

void VectorGetter(Ray *r1){
	double x, y, z, vx, vy, vz;
	cout<<"X: ";
	cin>>x;
	cout<<"Y: ";
	cin>>y;
	cout<<"Z: ";
	cin>>z;
	cout<<"VX: ";
	cin>>vx;
	cout<<"VY: ";
	cin>>vy;
	cout<<"VZ: ";
	cin>>vz;
	r1->RayPopulator(x, y, z, vx, vy, vz);
}

int main(){
	Ray r1, r2;
	Vector3 intersect;
	cout<<"Enter information for R1 - \n";
	VectorGetter(&r1);
	cout<<"\nEnter information for R2 - \n";
	VectorGetter(&r2);

	intersect = ApproximateRayIntersection(r1, r2);

	VectorPrinter(intersect);
	return 0;
}

