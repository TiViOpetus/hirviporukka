-- FUNCTION TO GET A MEMBER FROM JASEN TABLE BY JASEN ID

-- Create a function and set arguments 
CREATE FUNCTION public.get_member(
		id integer)

-- Define type of result set -> jasen table's structure
RETURNS SETOF public.jasen

-- Set language to standard sql
LANGUAGE SQL
AS $$ -- $$ is start of code block (BEGIN)
SELECT * FROM public.jasen WHERE jasen_id = id;
$$; -- $$ is end of the block (END)