const { requestPost } = require('./requestServer');

const queries = {
  directorates: 'SELECT directorate FROM USERS GROUP BY directorate ORDER BY directorate ASC'
};

export const getOfficials = async () => {
  try {
    const res = await requestPost('crud/find', { collection: 'users' });
    return res;
  } catch (error) {
    return { status: false };
  }
};

export const getDirectorates = async () => {
  try {
    const res = await requestPost('crud/query', { query: queries.directorates });
    return res;
  } catch (error) {
    return { status: false };
  }
};
