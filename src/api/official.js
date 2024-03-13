const { requestPost, requestGet } = require('./requestServer');

const queries = {
  directorates: 'SELECT directorate FROM USERS GROUP BY directorate ORDER BY directorate ASC'
};

export const getOfficials = async () => {
  try {
    const res = await requestGet('officials');
    return res;
  } catch (error) {
    return { status: false };
  }
};
export const getOne = async (official_id) => {
  try {
    const res = await requestGet('officials/getOne/' + official_id);
    return res;
  } catch (error) {
    return { status: false };
  }
};

export const deleteByID = async (official_id) => {
  try {
    const res = await requestGet('officials/deleteByID/' + official_id);
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
