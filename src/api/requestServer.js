import axios from 'axios';
const API_URL = process.env.REACT_APP_API_URL;
export const requestPost = async (URL, Body) => {
  try {
    const formData = new FormData();
    for (const key in Body) {
      formData.append(key, Body[key]);
    }
    debugger
    const res = await axios.post(API_URL + URL, formData);
    return res.data;
  } catch (error) {
    return error;
  }
};
export const requestPatch = async (URL, Body) => {
  try {
    const res = await axios.patch(API_URL + URL, Body);
    return res.data;
  } catch (error) {
    return error;
  }
};
export const requestGet = async (URL) => {
  try {
    const res = await axios.get(API_URL + URL);
    return res.data;
  } catch (error) {
    return error;
  }
};
