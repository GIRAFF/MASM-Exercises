#include <cstring>
#include <cstdio>
#include <cstdlib>
#include <locale>

extern "C" float work(int it);

int main(int argc, char **argv)
{
	int its;
	printf("iterations number, please: ");
	scanf("%d",&its);
	printf("as you wish.\n");
	printf("I guess I have what you need. Isn't it %f?\n", work(its));
	return 0;
}