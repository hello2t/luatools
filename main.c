

// #include <stdlib>

struct mapitem
{
	int x;
	int y;
	int data;
	int m;
	// int t;
};


int main(int argc, char const *argv[])
{
	/* code */

	for (int i = 0; i < 1024*1023; ++i)
	{
		struct mapitem * e= malloc(sizeof(*e));
		e->x =1;
		e->y=1;
		e->data=1;
		e->m=1;
		// e->t=1;
	}

	while(1==1){


	}

	return 0;
}