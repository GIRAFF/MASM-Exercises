#include <cstdio>
#include <cstring>

int main()
{
	char *buf = NULL;
	size_t len = 0;
	getline(&buf, &len, stdin);
	printf("%d", strlen(buf));
	return 0;
}
