import express from "express";
import axios from "axios";

const app = express();

if (process.env.NODE_ENV === "production") {
  app.use("/", express.static(__dirname + "/../client/build"));
} else {
  app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "http://localhost:3000");
    res.header("Access-Control-Allow-Headers", "Origin");
    res.header("Cache-Control", "no-cache, no-store, must-revalidate");
    next();
  });
}

app.get("/random-plane-points", (req, res) => {
  const url =
    "http://random-geometry-points-service.herokuapp.com/random-plane-points/3d/";
  const params = parseQueryParams(req.query);
  const urlWithParams = createUrl(url, params);
  axios
    .get(urlWithParams)
    .then(response => {
      const randomPoints = response.data.map(pnt => ({
        x: pnt.x_coord,
        y: pnt.y_coord,
        z: pnt.z_coord
      }));
      res.send(randomPoints);
    })
    .catch(error => {
      if (error.response) {
        if (error.response.data && error.response.data.message) {
          return res
            .status(error.response.status)
            .send(error.response.data.message);
        }
        return res.status(error.response.status).send("Unexpected error");
      } else if (error.request) {
        return res.status(503).send("Network error");
      } else {
        return res.status(500).send("Unexpected error");
      }
    });
});

app.listen(5000, () => {
  console.log("App listening on port 5000");
});

const parseQueryParams = queryParams =>
  Object.keys(queryParams).map(key => ({
    key: getParamApiName(key),
    value: queryParams[key]
  }));

const createUrl = (baseUrl, params) =>
  params.reduce((acc, param, index) => {
    const delim = index === 0 ? "?" : "&";
    return `${acc}${delim}${param.key}=${param.value}`;
  }, baseUrl);

const getParamApiName = paramType => {
  switch (paramType) {
    case "x":
      return "ref_x";
    case "y":
      return "ref_y";
    case "z":
      return "ref_z";
    case "i":
      return "n_x";
    case "j":
      return "n_y";
    case "k":
      return "n_z";
    case "radius":
      return "radius";
    case "number":
      return "num_points";
  }
};

export default app;
