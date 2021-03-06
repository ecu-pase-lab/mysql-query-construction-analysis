module lang::sql::mysql::AbstractSyntax

import lang::php::ast::AbstractSyntax;

public data SQLQuery = selectQuery(list[Exp] selectExpressions, list[Exp] from, Where where, GroupBy group, Having having, OrderBy order, Limit limit, list[Join] joins)
					 | updateQuery(list[Exp] tables, list[SetOp] setOps, Where where, OrderBy order, Limit limit)
					 | insertQuery(Into into, list[list[str]] values, list[SetOp] setOps, SQLQuery select, list[SetOp] onDuplicateSetOps)
					 | deleteQuery(list[Exp] from, list[str] using, Where where, OrderBy order, Limit limit)
					 | setQuery(list[SetOp] setOps)
					 | setOptionsQuery(str option, str val)
					 | dropQuery(list[Exp] fields, Exp table)
					 | alterQuery(Exp table) //TODO: altered fields and options
					 | replaceQuery(Into into, list[list[str]] values, list[SetOp] setOps, SQLQuery select)
					 | truncateQuery(Exp table)
					 | noQuery()// only here for queries that have the option to contain a SELECT query inside them
					 | unknownQuery()// logic to translate this query type into rascal is not yet implemented 
					 | partialStatement(PartialStatement statement)// part of the query text is contained in one or more query holes
					 | parseError();// query did not parse
					 
public data PartialStatement = unknownStatementType() // SELECT/DELETE/INSERT cannot be determined
							 | connectiveWithoutWhere(str queryType);
						

public data Exp = name(SQLName name)
			    | literal(str literalVal)
			    | call(str functionName)//TODO: function params
				| star()
				| unknownExp(str expression)
				| aliased(Exp exp, str theAlias)
				| noExp();
				
public data SQLName = column(str column)
					| table(str table)
					| database(str database)
					| tableColumn(str table, str column)
					| databaseTable(str database, str column)
					| databaseTableColumn(str database, str table, str column);

public data OrderBy = orderBy(rel[Exp exp, str mode] orderings)
					| noOrderBy();
					
public data GroupBy = groupBy(rel[Exp exp, str mode] groupings)
					| noGroupBy();
					
public data Where = where(Condition condition)
				  | noWhere();
				 
public data Having = having(Condition condition)
				   | noHaving();
				   
public data Condition = condition(SimpleCondition condition)
					  | and(Condition left, Condition right)
					  | or(Condition left, Condition right)
					  | xor(Condition left, Condition right)
					  | not(Condition negated);
					  
public data SimpleCondition = simpleComparison(str left, str op, str rightExp)
							| compoundComparison(str left, str op, SimpleCondition rightCondition)
							| between(bool not, str exp, str lower, str upper)
							| isNull(bool not, str exp)
							| inValues(bool not, str exp, list[str] values)
							| inSubquery(bool not, str exp, SQLQuery subquery)
							| like(bool not, str exp, str pattern)
							| unknown(str conditionText);//TODO: other condition types

public data Limit = limit(str numRows)
				  | limitWithOffset(str numRows, str offset)
				  | noLimit();

public data Join = simpleJoin(str joinType, Exp joinExp)
				 | joinOn(str joinType, Exp joinExp, Condition on)
				 | joinUsing(str joinType, Exp joinExp, list[str] using);
				 
public data Into = into(Exp dest, list[str] columns)
			     | noInto();
			     
public data SetOp = setOp(str column, str newValue); 