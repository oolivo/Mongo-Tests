fName = "John";
LName = "Smith";

for( i=0 ; i< 2000000;i++)
{

	if( i > 199999)
		LName = "Foster";

	if( i > 999999)
		fName = "Jeff";

	if( i > 1799999)
		LName = "Smith";

db.phonebook.insert( {"LastName" : LName, "FirstName" : fName } );


}
