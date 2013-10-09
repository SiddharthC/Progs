#include <stdio.h>
#include <string.h>


int removeAll(char *src, char *key){

	while (*src){
		printf("In second while\n");
		
		char *k = key, *s = src;
		
		while(*k && *k==*s) k++,s++;
		if(!*k){
			while(*s) *src++ = *s++;
			*src = '\0';
			return 1;
		}

		src++;
	}
	
	return 0;

}


int main(int argc, char * argv){

	char basestr[20]={0};
	char tarstr[20]={0};
	char *loc;

	printf("Enter the string for operation: ");
	scanf("%s",basestr);

	printf("Enter target string: ");
	scanf("%s",tarstr);

	while(removeAll(basestr, tarstr));

	printf("The remaining string is: %s\n", basestr);

	return 0;
}
