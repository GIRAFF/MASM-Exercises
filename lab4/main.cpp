#define _CRT_SECURE_NO_WARNINGS

#include <cstring>
#include <cstdio>
#include <cstdlib>
#include <locale>

extern "C" void __stdcall work(char* t);

int main(int argc, char **argv)
{
	char *text;
	FILE *f = fopen("text.txt", "rb");
	fseek(f, 0, SEEK_END);
	long fsize = ftell(f);
	rewind(f);

	text = (char*)malloc(fsize + 1);
	fread(text, fsize, 1, f);
	fclose(f);

	work(text);

	return 0;
}