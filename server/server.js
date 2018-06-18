import express from "express";
import axios from "axios";

const app = express();

if (process.env.NODE_ENV === "production") {
  console.log("production");
  app.use("/", express.static(__dirname + "/../client/build"));
} else {
  console.log("develop");
  app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "http://localhost:3000");
    res.header("Access-Control-Allow-Headers", "Origin");
    res.header("Cache-Control", "no-cache, no-store, must-revalidate");
    next();
  });
}

app.get("/hello", (req, res) => {
  res.send("Hello world!");
});

app.get("/random-plane-points", (req, res) => {
  const url =
    "http://random-geometry-points-service.herokuapp.com/random-plane-points/3d/";
  console.log("incoming request");
  console.log(req.query);

  const params = parseQueryParams(req.query);

  const urlWithParams = createUrl(url, params);

  console.log("starting request with url", urlWithParams);

  axios
    .get(urlWithParams)
    .then(response => {
      console.log("response", response);
      const randomPoints = response.data.map(pnt => ({
        x: pnt.x_coord,
        y: pnt.y_coord,
        z: pnt.z_coord
      }));
      res.send(randomPoints);
      console.log(randomPoints);
    })
    .catch(error => {
      console.log("an error occured");
      if (error.response) {
        console.error("server error", error.response.status);
        console.error("body", error.response.data);
        return res.status(500).send("error");
      } else if (error.request) {
        console.error("no server response");
        return res.status(500).send("error");
      } else {
        console.error("error when setting up request");
        return res.status(500).send("error");
      }
    });
  // res.send("getting plane points");
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
