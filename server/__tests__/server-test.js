import request from "supertest";
import axios from "axios";
import MockAdapter from "axios-mock-adapter";

const mockAxios = new MockAdapter(axios);

import app from "../server.js";

describe("server", () => {
  test("test1", () => {
    expect(2).toEqual(2);
  });
  test("test random plane points - failure with message", () => {
    mockAxios
      .onGet(
        "http://random-geometry-points-service.herokuapp.com/random-plane-points/3d/",
        {}
      )
      .reply(400, {
        message: "Invalid plane definition supplied"
      });
    const testUrl = "/random-plane-points";
    return request(app)
      .get(testUrl)
      .then(
        response => {
          mockAxios.reset();
          expect(response.statusCode).toEqual(400);
          expect(response.text).toEqual("Invalid plane definition supplied");
          return Promise.resolve();
        },
        _ => Promise.reject("Error during test")
      );
  });
  test("test random plane points - failure without message", () => {
    mockAxios
      .onGet(
        "http://random-geometry-points-service.herokuapp.com/random-plane-points/3d/",
        {}
      )
      .reply(400, {});
    const testUrl = "/random-plane-points";
    return request(app)
      .get(testUrl)
      .then(
        response => {
          mockAxios.reset();
          expect(response.statusCode).toEqual(400);
          expect(response.text).toEqual("Unexpected error");
          return Promise.resolve();
        },
        _ => Promise.reject("Error during test")
      );
  });
  test("test random plane points - success", () => {
    const baseUrl =
      "http://random-geometry-points-service.herokuapp.com/random-plane-points/3d/";
    const mockUrl = `${baseUrl}?radius=3&num_points=10&ref_x=-1.5&ref_y=3&ref_z=2.34&n_x=1&n_y=0&n_z=0`;
    mockAxios.onGet(mockUrl, {}).reply(200, [
      {
        x_coord: 1,
        y_coord: 2,
        z_coord: 3
      },
      {
        x_coord: -1.5,
        y_coord: 2.23,
        z_coord: 0
      }
    ]);
    const testUrl =
      "/random-plane-points?radius=3&number=10&x=-1.5&y=3&z=2.34&i=1&j=0&k=0";
    return request(app)
      .get(testUrl)
      .then(
        response => {
          mockAxios.reset();
          expect(response.statusCode).toEqual(200);
          expect(response.body).toEqual([
            {
              x: 1,
              y: 2,
              z: 3
            },
            {
              x: -1.5,
              y: 2.23,
              z: 0
            }
          ]);
          return Promise.resolve();
        },
        _ => Promise.reject("Error during test")
      );
  });
});
