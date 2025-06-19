const oracledb = require('oracledb');

const dbConfig = {
  user: "c##easylingo",
  password: "123",
  connectString: "localhost:1521/orcl",
};

const executeQuery = async (query, params = []) => {
  let conn;
  try {
    console.log('Attempting database connection...');
    conn = await oracledb.getConnection(dbConfig);
    console.log('Database connection successful');
    
    console.log('Executing query:', query);
    const result = await conn.execute(query, params, { 
      outFormat: oracledb.OUT_FORMAT_OBJECT 
    });
    console.log('Query executed successfully');
    return result;
  } catch (err) {
    console.error('Database error:', err);
    console.error('Error stack:', err.stack);
    throw err;
  } finally {
    if (conn) {
      try {
        console.log('Closing database connection...');
        await conn.close();
        console.log('Database connection closed');
      } catch (err) {
        console.error('Error closing connection:', err);
      }
    }
  }
};

module.exports = {
  executeQuery
}; 