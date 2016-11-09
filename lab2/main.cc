#include <cstring>
#include <cstdio>
#include <cstdlib>
#include <locale>

extern "C"
int indexof(char* str, char* sub);

extern "C"
char* getline()
{
	char* name = (char*)calloc(1, 255);
	scanf("%s", name);
	//while (getchar() != '\n');
	return name;
}

int main(int argc, char **argv)
{
	char *str, *sub;
	int iof;
	printf("Type string:\n");
	str = getline();
	printf("Type substring:\n");
	sub = getline();
	//printf("%s\n%s",str,sub);
	if ((iof = indexof(str, sub)) == -1)
		printf("Substring not found.\n");
	else
		printf("index = %d\n", iof);
	return 0;
}