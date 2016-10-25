#include <cstdio>
#include <cstring>

extern "C" int indexof(char* str, int str_len,
		char* sub, int sub_len);

int main(int argc, char **argv)
{
	char *str = NULL;
	char *sub = NULL;
	size_t len = 0;
	int iof;
	printf("Введите строку:\n");
	getline(&str, &len, stdin);
	printf("Введите искомую подстроку:\n");
	getline(&sub, &len, stdin);
	if((iof = indexof(str,strlen(str),sub,strlen(sub))) == -1)
		printf("Подстрока не найдена.\n");
	else
		printf("Индекс первого вхождения подстроки: %d\n", iof);
	return 0;
}
