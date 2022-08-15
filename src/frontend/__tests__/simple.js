
import server from '../server';
import supertest from 'supertest';
const requestWithSupertest = supertest(server);

describe("Testing with Jest", () => {
  test("Addition", () => {
    const sum = 2 + 3;
    const expectedResult = 5;
    expect(sum).toEqual(expectedResult);
  });
});

describe('User Endpoints', () => {
  it('GET / homepage', async () => {
    const res = await requestWithSupertest.get('/');
      expect(res.status).toEqual(200);
      expect(res.type).toEqual(expect.stringContaining('html'));
  });
});


describe('User Endpoints', () => {
  it('GET /merger', async () => {
    const res = await requestWithSupertest.get('/merger');
      expect(res.status).toEqual(200);
      expect(res.type).toEqual(expect.stringContaining('html'));
  });
});

describe('User Endpoints', () => {
  it('GET /rotator', async () => {
    const res = await requestWithSupertest.get('/rotator');
      expect(res.status).toEqual(200);
      expect(res.type).toEqual(expect.stringContaining('html'));
      // expect(res.body).toHaveProperty('users')
  });
});


describe('User Endpoints', () => {
  it('GET /about', async () => {
    const res = await requestWithSupertest.get('/about');
      expect(res.status).toEqual(200);
      expect(res.type).toEqual(expect.stringContaining('html'));
      // expect(res.body).toHaveProperty('users')
  });
});
