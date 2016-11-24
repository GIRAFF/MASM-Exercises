#include <cstring>
#include <cstdio>
#include <cstdlib>
#include <locale>

extern "C" float work(float it);

int main(int argc, char **argv)
{
	float acc;
	printf("accuracy, please: ");
	scanf("%f", &acc);
	printf("as you wish.\n");
	printf("I guess I have what you need. Isn't it %f?\n", work(acc));
	return 0;
}